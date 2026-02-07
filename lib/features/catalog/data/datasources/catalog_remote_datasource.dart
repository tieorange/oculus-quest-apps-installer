// ignore_for_file: avoid_slow_async_io

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quest_game_manager/core/constants/app_constants.dart';
import 'package:quest_game_manager/core/error/exceptions.dart';
import 'package:quest_game_manager/features/catalog/data/models/game_info_model.dart';
import 'package:quest_game_manager/features/config/domain/entities/public_config.dart';

/// Remote data source for fetching game catalog.
@lazySingleton
class CatalogRemoteDatasource {
  CatalogRemoteDatasource(this._dio);
  final Dio _dio;

  /// Downloads meta.7z, extracts it, and parses VRP-GameList.txt.
  Future<List<GameInfoModel>> fetchCatalog(PublicConfig config) async {
    final cacheDir = await getApplicationCacheDirectory();
    final metaPath = '${cacheDir.path}/${AppConstants.metaArchiveName}';
    final dataDir = await getApplicationDocumentsDirectory();

    // Download meta.7z
    await _dio.download('${config.baseUri}/${AppConstants.metaArchiveName}', metaPath);

    // Extract with 7za
    final extractResult = await Process.run('7za', [
      'x',
      metaPath,
      '-aoa',
      '-o${dataDir.path}',
      '-p${config.password}',
    ]);

    if (extractResult.exitCode != 0) {
      throw ExtractionException(message: 'Failed to extract meta.7z: ${extractResult.stderr}');
    }

    // Parse game list
    final gameListFile = File('${dataDir.path}/${AppConstants.gameListFileName}');
    if (!await gameListFile.exists()) {
      throw const StorageException(message: 'Game list file not found');
    }

    final lines = await gameListFile.readAsLines();
    final games = <GameInfoModel>[];

    for (var i = 1; i < lines.length; i++) {
      // Skip header
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      try {
        games.add(GameInfoModel.fromCsvLine(line));
      } catch (_) {
        // Skip malformed lines
      }
    }

    return games;
  }

  /// Gets the path to a game's thumbnail.
  Future<String?> getThumbnailPath(String packageName) async {
    final dataDir = await getApplicationDocumentsDirectory();
    final path = '${dataDir.path}/${AppConstants.thumbnailsPath}/$packageName.jpg';
    final file = File(path);
    if (await file.exists()) {
      return path;
    }
    return null;
  }
}
