import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quest_game_manager/core/error/exceptions.dart';
import 'package:quest_game_manager/core/utils/app_logger.dart';
import 'package:quest_game_manager/core/utils/hash_utils.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';
import 'package:quest_game_manager/features/downloads/domain/entities/download_task.dart';

/// Remote datasource for downloading games.
/// Uses Dio HTTP client with rclone User-Agent for Cloudflare compatibility.
///
/// Uses "blind download" approach without HEAD probing to avoid Cloudflare rate limiting.
@lazySingleton
class DownloadRemoteDatasource {
  DownloadRemoteDatasource(this._dio);
  final Dio _dio;

  bool _isCancelled = false;
  CancelToken? _cancelToken;

  // Same User-Agent as rclone/rookie to bypass WAF
  static const _userAgent = 'rclone/v1.66.0';

  /// Downloads a game and emits progress updates.
  ///
  /// Uses blind download approach - attempts to download files sequentially
  /// without HEAD probing to avoid Cloudflare rate limiting.
  Stream<DownloadTask> downloadGame({
    required Game game,
    required String baseUri,
    required String password,
  }) async* {
    final gameId = HashUtils.computeGameId(game.releaseName);
    AppLogger.info('Starting download for: ${game.name}', tag: 'DownloadDS');
    AppLogger.debug('Game ID: $gameId', tag: 'DownloadDS');
    AppLogger.debug('Base URI: $baseUri', tag: 'DownloadDS');
    AppLogger.debug('User-Agent: $_userAgent', tag: 'DownloadDS');

    final task = DownloadTask(
      game: game,
      gameId: gameId,
      status: DownloadStatus.queued,
    );

    _isCancelled = false;
    _cancelToken = CancelToken();

    yield task.copyWith(status: DownloadStatus.downloading);

    try {
      // 1. Prepare cache directory for download
      final cacheDir = await getApplicationCacheDirectory();
      final downloadDir = Directory('${cacheDir.path}/$gameId');
      if (!downloadDir.existsSync()) {
        downloadDir.createSync(recursive: true);
      }

      AppLogger.debug('Download dir: ${downloadDir.path}', tag: 'DownloadDS');

      // 2. Prepare headers (same as catalog download)
      final normalizedBaseUri = _normalizeBaseUri(baseUri);
      final authToken = base64.encode(utf8.encode(':$password'));
      final headers = {
        'Authorization': 'Basic $authToken',
        'User-Agent': _userAgent,
        'Accept': '*/*',
      };

      // 3. Download files using blind approach (no HEAD probing)
      // Try to download .7z.001, .7z.002, etc. until we get a 404
      var partNumber = 1;
      var totalDownloaded = 0;
      final startTime = DateTime.now();
      final downloadedFiles = <String>[];

      AppLogger.info('Starting blind download (no probing)...', tag: 'DownloadDS');

      while (!_isCancelled) {
        final fileName = '$gameId.7z.${partNumber.toString().padLeft(3, '0')}';
        final fileUrl = '$normalizedBaseUri$gameId/$fileName';
        final filePath = '${downloadDir.path}/$fileName';

        AppLogger.debug('Trying to download: $fileName', tag: 'DownloadDS');

        try {
          var lastProgress = 0.0;

          await _dio.download(
            fileUrl,
            filePath,
            cancelToken: _cancelToken,
            options: Options(
              headers: headers,
              // Accept 2xx as success, throw on 4xx/5xx
              validateStatus: (status) => status != null && status >= 200 && status < 300,
            ),
            onReceiveProgress: (received, total) {
              if (total > 0) {
                final progress = received / total;
                // Log every 10% progress
                if (progress - lastProgress >= 0.1) {
                  lastProgress = progress;
                  AppLogger.debug(
                    'Part $partNumber: ${(progress * 100).toStringAsFixed(0)}% (${_formatBytes(received)}/${_formatBytes(total)})',
                    tag: 'DownloadDS',
                  );
                }
              }
            },
          );

          // Success! File downloaded
          final fileSize = await File(filePath).length();
          totalDownloaded += fileSize;
          downloadedFiles.add(fileName);

          AppLogger.info(
            'Downloaded: $fileName (${_formatBytes(fileSize)})',
            tag: 'DownloadDS',
          );

          // Emit progress update
          yield task.copyWith(
            status: DownloadStatus.downloading,
            progress: 0.5 * (partNumber / 10).clamp(0, 0.5), // Estimate progress
            bytesReceived: totalDownloaded,
            speedBytesPerSecond:
                totalDownloaded / (DateTime.now().difference(startTime).inMilliseconds / 1000),
          );

          partNumber++;

          // Safety limit
          if (partNumber > 999) {
            AppLogger.warning('Reached max parts limit (999)', tag: 'DownloadDS');
            break;
          }
        } on DioException catch (e) {
          if (e.response?.statusCode == 404) {
            // File doesn't exist - we've downloaded all parts
            AppLogger.info('No more parts (404 on part $partNumber)', tag: 'DownloadDS');
            break;
          } else if (e.response?.statusCode == 403) {
            if (downloadedFiles.isEmpty) {
              // First file blocked - this is a real error
              AppLogger.error(
                '403 Forbidden on first file - access blocked',
                tag: 'DownloadDS',
              );
              throw const DownloadException(
                message: 'Access forbidden (403) - server blocked download',
              );
            }
            // Already downloaded some files, 403 might mean no more parts
            // (Cloudflare sometimes returns 403 instead of 404)
            AppLogger.info(
              '403 after ${downloadedFiles.length} files - assuming no more parts',
              tag: 'DownloadDS',
            );
            break;
          } else if (e.type == DioExceptionType.cancel) {
            AppLogger.info('Download cancelled', tag: 'DownloadDS');
            yield task.copyWith(status: DownloadStatus.paused);
            return;
          } else {
            // Other error - rethrow
            rethrow;
          }
        }
      }

      if (_isCancelled) {
        yield task.copyWith(status: DownloadStatus.paused);
        return;
      }

      if (downloadedFiles.isEmpty) {
        throw const DownloadException(
          message: 'No game files could be downloaded',
        );
      }

      AppLogger.info(
        'Downloaded ${downloadedFiles.length} parts, total: ${_formatBytes(totalDownloaded)}',
        tag: 'DownloadDS',
      );

      // 4. Find the .7z.001 file for extraction
      final archiveFile = File('${downloadDir.path}/${downloadedFiles.first}');
      if (!archiveFile.existsSync()) {
        throw const ExtractionException(
          message: 'Archive file not found after download',
        );
      }

      AppLogger.info('Starting extraction: ${archiveFile.path}', tag: 'DownloadDS');

      // 5. Extraction phase
      yield task.copyWith(
        status: DownloadStatus.extracting,
        progress: 0.5,
      );

      const channel = MethodChannel('com.questgamemanager.quest_game_manager/archive');
      try {
        await channel.invokeMethod<bool>('extract7z', {
          'filePath': archiveFile.path,
          'outDir': downloadDir.path,
          'password': password,
        });
        AppLogger.info('Extraction complete', tag: 'DownloadDS');
      } on PlatformException catch (e) {
        AppLogger.error('Extraction failed: ${e.message}', tag: 'DownloadDS');
        throw ExtractionException(message: 'Extraction failed: ${e.message}');
      }

      // 6. Clean up archive files
      await _cleanupArchiveFiles(downloadDir);

      yield task.copyWith(
        status: DownloadStatus.completed,
        progress: 1,
      );
    } catch (e, st) {
      AppLogger.error('Download failed', tag: 'DownloadDS', error: e, stackTrace: st);
      yield task.copyWith(
        status: DownloadStatus.failed,
      );
    }
  }

  /// Normalizes the base URI to ensure it ends with a slash.
  String _normalizeBaseUri(String uri) {
    return uri.endsWith('/') ? uri : '$uri/';
  }

  /// Cleans up archive files after extraction.
  Future<void> _cleanupArchiveFiles(Directory dir) async {
    AppLogger.debug('Cleaning up archive files...', tag: 'DownloadDS');
    try {
      await for (final entity in dir.list()) {
        if (entity is File && entity.path.contains('.7z.')) {
          await entity.delete();
          AppLogger.debug('Deleted: ${entity.path}', tag: 'DownloadDS');
        }
      }
    } catch (e) {
      AppLogger.warning('Cleanup failed: $e', tag: 'DownloadDS');
    }
  }

  /// Formats bytes into human-readable string.
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  /// Cancels the current download.
  void cancelDownload() {
    _isCancelled = true;
    _cancelToken?.cancel('User cancelled');
  }
}
