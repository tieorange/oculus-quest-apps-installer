import 'dart:convert';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quest_game_manager/core/constants/app_constants.dart';
import 'package:quest_game_manager/core/error/exceptions.dart';
import 'package:quest_game_manager/core/utils/app_logger.dart';
import 'package:quest_game_manager/features/config/data/models/public_config_model.dart';

/// Local data source for caching app configuration.
@lazySingleton
class ConfigLocalDatasource {
  Future<String> _getConfigPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/vrp-public.json';
  }

  /// Gets cached config from local storage.
  /// Returns null if file doesn't exist or is empty.
  Future<PublicConfigModel?> getConfig() async {
    try {
      final path = await _getConfigPath();
      final file = File(path);

      if (!file.existsSync()) {
        AppLogger.debug('Local config file not found, creating default', tag: 'ConfigLocalDS');
        await file.writeAsString(AppConstants.defaultConfigJson);
        // Fall through to read it
      }

      final content = await file.readAsString();
      if (content.trim().isEmpty) {
        AppLogger.info('Local config file is empty, writing default', tag: 'ConfigLocalDS');
        await file.writeAsString(AppConstants.defaultConfigJson);
        // Fall through to read it
        return getConfig(); // Recurse once
      }

      // If parsing fails, we might want to return null to refetch, or throw if we trust the file.
      // Given user might create malformed files, let's log and return null.
      try {
        final jsonMap = json.decode(content) as Map<String, dynamic>;
        AppLogger.info(
          'Loaded local config. Base URI: ${jsonMap['baseUri']}',
          tag: 'ConfigLocalDS',
        );
        return PublicConfigModel.fromJson(jsonMap);
      } catch (e) {
        AppLogger.warning('Failed to parse local config file: $e', tag: 'ConfigLocalDS');
        return null;
      }
    } catch (e) {
      AppLogger.error('Error reading local config', tag: 'ConfigLocalDS', error: e);
      throw StorageException(message: e.toString());
    }
  }

  /// Saves config to local storage.
  Future<void> saveConfig(PublicConfigModel config) async {
    try {
      final path = await _getConfigPath();
      final file = File(path);
      final jsonString = json.encode(config.toJson());
      await file.writeAsString(jsonString);
      AppLogger.info('Saved config to local file: $path', tag: 'ConfigLocalDS');
    } catch (e) {
      AppLogger.error('Error saving local config', tag: 'ConfigLocalDS', error: e);
      throw StorageException(message: e.toString());
    }
  }
}
