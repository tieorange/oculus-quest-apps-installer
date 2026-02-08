import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quest_game_manager/core/constants/app_constants.dart';
import 'package:quest_game_manager/core/error/exceptions.dart';
import 'package:quest_game_manager/core/utils/app_logger.dart';
import 'package:quest_game_manager/core/utils/hash_utils.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';
import 'package:quest_game_manager/features/downloads/domain/entities/download_task.dart';

/// Remote datasource for downloading games.
@lazySingleton
class DownloadRemoteDatasource {
  DownloadRemoteDatasource(this._dio);
  final Dio _dio;

  bool _isCancelled = false;
  CancelToken? _cancelToken;

  /// Downloads a game and emits progress updates through the full pipeline.
  Stream<DownloadTask> downloadGame({
    required Game game,
    required String baseUri,
    required String password,
  }) async* {
    final gameId = HashUtils.computeGameId(game.releaseName);
    AppLogger.info('Starting download for: ${game.name} (ID: $gameId)', tag: 'DownloadDS');

    final task = DownloadTask(
      game: game,
      gameId: gameId,
      status: DownloadStatus.queued,
    );

    _isCancelled = false;
    _cancelToken = CancelToken();

    yield task.copyWith(status: DownloadStatus.downloading);

    try {
      final cacheDir = await getApplicationCacheDirectory();
      final downloadDir = Directory('${cacheDir.path}/$gameId');
      await downloadDir.create(recursive: true);

      final normalizedBaseUri = baseUri.endsWith('/') ? baseUri : '$baseUri/';
      final authToken = base64.encode(utf8.encode(':$password'));
      final headers = {
        'Authorization': 'Basic $authToken',
        'User-Agent': AppConstants.userAgent,
        'Accept': '*/*',
      };

      // --- DOWNLOAD PHASE ---
      var partNumber = 1;
      var totalDownloaded = 0;
      final startTime = DateTime.now();
      final downloadedFiles = <String>[];

      while (!_isCancelled) {
        final fileName = '$gameId.7z.${partNumber.toString().padLeft(3, '0')}';
        final fileUrl = '$normalizedBaseUri$gameId/$fileName';
        final filePath = '${downloadDir.path}/$fileName';
        final tmpPath = '$filePath.tmp';

        // Check for existing partial download
        var offset = 0;
        final tmpFile = File(tmpPath);
        if (tmpFile.existsSync()) {
          offset = await tmpFile.length();
        }

        try {
          await _dio.download(
            fileUrl,
            tmpPath,
            cancelToken: _cancelToken,
            options: Options(
              headers: {
                ...headers,
                if (offset > 0) 'Range': 'bytes=$offset-',
              },
              validateStatus: (status) => status != null && status >= 200 && status < 300,
            ),
            deleteOnError: false,
            onReceiveProgress: (received, total) {
              // Emit progress will be handled per-part completion
            },
          );

          // Rename tmp to final
          await File(tmpPath).rename(filePath);

          final fileSize = await File(filePath).length();
          totalDownloaded += fileSize;
          downloadedFiles.add(fileName);

          AppLogger.info('Downloaded part $partNumber: $fileName', tag: 'DownloadDS');

          yield task.copyWith(
            status: DownloadStatus.downloading,
            pipelineStage: PipelineStage.downloading,
            progress: 0.4 * (partNumber / (partNumber + 1)),
            bytesReceived: totalDownloaded,
            currentPart: partNumber,
            totalParts: partNumber,
            speedBytesPerSecond: totalDownloaded /
                (DateTime.now().difference(startTime).inMilliseconds / 1000)
                    .clamp(0.1, double.infinity),
          );

          partNumber++;
          if (partNumber > 999) break;
        } on DioException catch (e) {
          if (e.response?.statusCode == 404 || e.response?.statusCode == 403) {
            if (downloadedFiles.isEmpty && e.response?.statusCode == 403) {
              throw const DownloadException(message: 'Access forbidden (403)');
            }
            break; // No more parts
          } else if (e.type == DioExceptionType.cancel) {
            yield task.copyWith(status: DownloadStatus.paused);
            return;
          } else {
            rethrow;
          }
        }
      }

      if (_isCancelled) {
        yield task.copyWith(status: DownloadStatus.paused);
        return;
      }

      if (downloadedFiles.isEmpty) {
        throw const DownloadException(message: 'No game files could be downloaded');
      }

      // Update total parts now that we know
      yield task.copyWith(
        status: DownloadStatus.downloading,
        progress: 0.4,
        totalParts: downloadedFiles.length,
        currentPart: downloadedFiles.length,
      );

      // --- EXTRACTION PHASE ---
      yield task.copyWith(
        status: DownloadStatus.extracting,
        pipelineStage: PipelineStage.extracting,
        progress: 0.5,
      );

      final archiveFile = File('${downloadDir.path}/${downloadedFiles.first}');
      const channel = MethodChannel(AppConstants.archiveChannel);
      try {
        await channel.invokeMethod<bool>('extract7z', {
          'filePath': archiveFile.path,
          'outDir': downloadDir.path,
          'password': password,
        });
        AppLogger.info('Extraction complete', tag: 'DownloadDS');
      } on PlatformException catch (e) {
        throw ExtractionException(message: 'Extraction failed: ${e.message}');
      }

      // Clean up archive files
      await for (final entity in downloadDir.list()) {
        if (entity is File && entity.path.contains('.7z.')) {
          await entity.delete();
        }
      }

      yield task.copyWith(
        status: DownloadStatus.extracting,
        pipelineStage: PipelineStage.extracting,
        progress: 0.7,
      );

      // --- INSTALL PHASE ---
      yield task.copyWith(
        status: DownloadStatus.installing,
        pipelineStage: PipelineStage.installing,
        progress: 0.75,
      );

      // Find APK files
      final apkFiles = <File>[];
      await for (final entity in downloadDir.list(recursive: true)) {
        if (entity is File && entity.path.endsWith('.apk')) {
          apkFiles.add(entity);
        }
      }

      if (apkFiles.isNotEmpty) {
        const installerChannel = MethodChannel(AppConstants.installerChannel);
        for (final apk in apkFiles) {
          AppLogger.info('Installing: ${apk.path}', tag: 'DownloadDS');
          try {
            final result = await installerChannel.invokeMethod<Map<Object?, Object?>>(
              'installApk',
              {'apkPath': apk.path},
            );
            final success = result?['success'] as bool? ?? false;
            if (!success) {
              final msg = result?['message']?.toString() ?? 'Unknown error';
              AppLogger.warning('Install result: $msg', tag: 'DownloadDS');
            }
          } catch (e) {
            AppLogger.error('APK install error: $e', tag: 'DownloadDS');
          }
        }
      }

      yield task.copyWith(
        status: DownloadStatus.installing,
        pipelineStage: PipelineStage.copyingObb,
        progress: 0.85,
      );

      // --- OBB COPY PHASE ---
      // Search for OBB files recursively (archives may extract to varying structures)
      final obbFiles = <File>[];
      await for (final entity in downloadDir.list(recursive: true)) {
        if (entity is File && entity.path.endsWith('.obb')) {
          obbFiles.add(entity);
        }
      }

      // Also check for the conventional package-name subdirectory with data files
      final obbSourceDir = Directory('${downloadDir.path}/${game.packageName}');
      if (obbSourceDir.existsSync()) {
        await for (final entity in obbSourceDir.list(recursive: true)) {
          if (entity is File && !entity.path.endsWith('.obb') && !entity.path.endsWith('.apk')) {
            obbFiles.add(entity);
          }
        }
      }

      if (obbFiles.isNotEmpty) {
        final obbTargetDir = Directory('${AppConstants.obbBasePath}/${game.packageName}');
        if (obbTargetDir.existsSync()) {
          await obbTargetDir.delete(recursive: true);
        }
        await obbTargetDir.create(recursive: true);

        for (final obbFile in obbFiles) {
          final fileName = obbFile.uri.pathSegments.last;
          await obbFile.copy('${obbTargetDir.path}/$fileName');
          AppLogger.info('Copied OBB/data: $fileName', tag: 'DownloadDS');
        }
      }

      // --- CLEANUP PHASE ---
      yield task.copyWith(
        pipelineStage: PipelineStage.cleaning,
        progress: 0.95,
      );

      // Clean up extracted files but keep the dir structure info
      try {
        await downloadDir.delete(recursive: true);
      } catch (e) {
        AppLogger.warning('Cleanup partial: $e', tag: 'DownloadDS');
      }

      yield task.copyWith(
        status: DownloadStatus.completed,
        pipelineStage: PipelineStage.done,
        progress: 1,
      );
    } catch (e, st) {
      AppLogger.error('Download pipeline failed', tag: 'DownloadDS', error: e, stackTrace: st);
      yield task.copyWith(status: DownloadStatus.failed);
    }
  }

  /// Cancels the current download.
  void cancelDownload() {
    _isCancelled = true;
    _cancelToken?.cancel('User cancelled');
  }
}
