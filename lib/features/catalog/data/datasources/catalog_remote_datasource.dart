// ignore_for_file: avoid_slow_async_io

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quest_game_manager/core/constants/app_constants.dart';
import 'package:quest_game_manager/core/error/exceptions.dart';
import 'package:quest_game_manager/core/utils/app_logger.dart';
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

    AppLogger.debug('Cache dir: ${cacheDir.path}', tag: 'CatalogDS');
    AppLogger.debug('Data dir: ${dataDir.path}', tag: 'CatalogDS');

    // Download meta.7z
    final baseUrl = config.baseUri.endsWith('/')
        ? config.baseUri.substring(0, config.baseUri.length - 1)
        : config.baseUri;
    final downloadUrl = '$baseUrl/${AppConstants.metaArchiveName}';
    AppLogger.info('Downloading meta archive from: $downloadUrl', tag: 'CatalogDS');
    // Use rclone User-Agent to match standard client
    const userAgent = 'rclone/v1.66.0';
    AppLogger.debug('Using User-Agent: $userAgent', tag: 'CatalogDS');

    final token = base64.encode(utf8.encode(':${config.password}'));
    try {
      await _dio.download(
        downloadUrl,
        metaPath,
        options: Options(
          headers: {
            'Authorization': 'Basic $token',
            'User-Agent': userAgent,
            'Accept': '*/*',
          },
        ),
      );
      AppLogger.info('Download complete: $metaPath', tag: 'CatalogDS');
    } catch (e, st) {
      AppLogger.error('Download failed', tag: 'CatalogDS', error: e, stackTrace: st);
      rethrow;
    }

    // Extract with 7za
    AppLogger.info('Extracting archive via native channel...', tag: 'CatalogDS');

    const channel = MethodChannel('com.questgamemanager.quest_game_manager/archive');
    try {
      await channel.invokeMethod<bool>('extract7z', {
        'filePath': metaPath,
        'outDir': dataDir.path,
        'password': config.password,
      });
      AppLogger.info('Extraction complete', tag: 'CatalogDS');
    } on PlatformException catch (e) {
      AppLogger.error('Extraction failed: ${e.message}', tag: 'CatalogDS');
      throw ExtractionException(message: 'Failed to extract meta.7z: ${e.message}');
    }

    // Parse game list
    final gameListFile = File('${dataDir.path}/${AppConstants.gameListFileName}');
    AppLogger.debug('Looking for game list at: ${gameListFile.path}', tag: 'CatalogDS');
    if (!await gameListFile.exists()) {
      AppLogger.error('Game list file not found', tag: 'CatalogDS');
      throw const StorageException(message: 'Game list file not found');
    }

    final lines = await gameListFile.readAsLines();
    AppLogger.info('Parsing ${lines.length} lines from game list', tag: 'CatalogDS');
    final games = <GameInfoModel>[];
    var skipped = 0;

    for (var i = 1; i < lines.length; i++) {
      // Skip header
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      try {
        games.add(GameInfoModel.fromCsvLine(line));
      } catch (e) {
        skipped++;
        AppLogger.warning('Skipping malformed line $i: $e', tag: 'CatalogDS');
      }
    }

    AppLogger.info('Parsed ${games.length} games ($skipped skipped)', tag: 'CatalogDS');
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
