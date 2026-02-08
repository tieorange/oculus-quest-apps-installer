import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:disk_space_2/disk_space_2.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quest_game_manager/core/constants/app_constants.dart';
import 'package:quest_game_manager/core/error/exceptions.dart';
import 'package:quest_game_manager/core/utils/app_logger.dart';
import 'package:quest_game_manager/core/utils/file_utils.dart';
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
  /// Downloads a game and emits progress updates through the full pipeline.
  Stream<DownloadTask> downloadGame({
    required Game game,
    required String baseUri,
    required String password,
  }) {
    // Use a StreamController to allow emitting events from callbacks (Dio onReceiveProgress)
    final controller = StreamController<DownloadTask>();

    // Run the download logic in a separate async operation
    _startDownload(controller, game, baseUri, password);

    return controller.stream;
  }

  Future<void> _startDownload(
    StreamController<DownloadTask> controller,
    Game game,
    String baseUri,
    String password,
  ) async {
    final gameId = HashUtils.computeGameId(game.releaseName);
    AppLogger.info('Starting download for: ${game.name} (ID: $gameId)', tag: 'DownloadDS');

    var task = DownloadTask(
      game: game,
      gameId: gameId,
      status: DownloadStatus.queued,
    );

    _isCancelled = false;
    _cancelToken = CancelToken();

    void emit(DownloadTask updatedTask) {
      if (!controller.isClosed) {
        controller.add(updatedTask);
        task = updatedTask; // Keep local task updated
      }
    }

    emit(task.copyWith(status: DownloadStatus.downloading));

    try {
      Directory? baseDir;
      if (Platform.isAndroid) {
        baseDir = await getExternalStorageDirectory();
      }
      baseDir ??= await getApplicationSupportDirectory();

      // Check available space
      // buffer of 200MB + game size
      final requiredMb = game.sizeInMb + 200;
      final freeSpaceMb = await DiskSpace.getFreeDiskSpaceForPath(baseDir.path);

      if (freeSpaceMb != null && freeSpaceMb < requiredMb) {
        throw DownloadException(
          message:
              'Insufficient space. Required: ${requiredMb}MB, Available: ${freeSpaceMb.toInt()}MB',
        );
      }

      final downloadDir = Directory('${baseDir.path}/$gameId');
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

      // Calculate total bytes roughly from MB to bytes
      final totalBytesExpected = game.sizeInMb * 1024 * 1024;

      // For ETA calculation
      var lastEmitTime = DateTime.now();
      const throttleDuration = Duration(milliseconds: 200);

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
              if (controller.isClosed || _isCancelled) return;

              final now = DateTime.now();
              if (now.difference(lastEmitTime) < throttleDuration) return;
              lastEmitTime = now;

              // Calculate progress
              // received is bytes received for THIS request (part)
              // But 'received' in dio callback includes the 'offset' if resuming?
              // Actually dio's onReceiveProgress 'count' is bytes received in this response body.
              // If we used Range header, 'count' is the chunk size.
              // So actual bytes on disk for this part = offset + received.
              // But 'total' in callback is Content-Length of response, so it's the remaining size.

              // Total downloaded so far across all parts = totalDownloaded + offset + received
              final currentTotalDownloaded = totalDownloaded + offset + received;
              final progress = 0.9 * (currentTotalDownloaded / totalBytesExpected); // cap at 0.9

              // Calculate Speed & ETA
              final elapsedSeconds = now.difference(startTime).inMilliseconds / 1000.0;
              final speedBps = elapsedSeconds > 0 ? currentTotalDownloaded / elapsedSeconds : 0.0;

              Duration? eta;
              if (speedBps > 0 && totalBytesExpected > currentTotalDownloaded) {
                final remainingBytes = totalBytesExpected - currentTotalDownloaded;
                final etaSeconds = remainingBytes / speedBps;
                eta = Duration(seconds: etaSeconds.toInt());
              }

              emit(task.copyWith(
                status: DownloadStatus.downloading,
                pipelineStage: PipelineStage.downloading,
                progress: progress.clamp(0.0, 0.9),
                bytesReceived: currentTotalDownloaded,
                currentPart: partNumber,
                // We keep totalParts as currentPart until we know better or finish
                totalParts: partNumber,
                speedBytesPerSecond: speedBps,
                eta: eta,
              ));
            },
          );

          // Rename tmp to final
          await File(tmpPath).rename(filePath);

          final fileSize = await File(filePath).length();
          totalDownloaded += fileSize;
          downloadedFiles.add(fileName);

          AppLogger.info('Downloaded part $partNumber: $fileName', tag: 'DownloadDS');

          // Emit completion of part to ensure we hit the exact totalDownloaded mark
          emit(task.copyWith(
            status: DownloadStatus.downloading,
            pipelineStage: PipelineStage.downloading,
            progress: (0.9 * (totalDownloaded / totalBytesExpected)).clamp(0.0, 0.9),
            bytesReceived: totalDownloaded,
            currentPart: partNumber,
            totalParts: partNumber,
          ));

          partNumber++;
          if (partNumber > 999) break;
        } on DioException catch (e) {
          if (e.response?.statusCode == 404 || e.response?.statusCode == 403) {
            if (downloadedFiles.isEmpty && e.response?.statusCode == 403) {
              throw const DownloadException(message: 'Access forbidden (403)');
            }
            break; // No more parts
          } else if (e.type == DioExceptionType.cancel) {
            emit(task.copyWith(status: DownloadStatus.paused));
            await controller.close();
            return;
          } else {
            rethrow;
          }
        }
      }

      if (_isCancelled) {
        emit(task.copyWith(status: DownloadStatus.paused));
        await controller.close();
        return;
      }

      if (downloadedFiles.isEmpty) {
        throw const DownloadException(message: 'No game files could be downloaded');
      }

      // Update total parts now that we know
      emit(task.copyWith(
        status: DownloadStatus.downloading,
        progress: 0.9,
        totalParts: downloadedFiles.length,
        currentPart: downloadedFiles.length,
        eta: Duration.zero,
      ));

      // --- EXTRACTION PHASE ---
      emit(task.copyWith(
        status: DownloadStatus.extracting,
        pipelineStage: PipelineStage.extracting,
        progress: 0.90, // Start extraction at 90%
        eta: null,
      ));

      final archiveFile = File('${downloadDir.path}/${downloadedFiles.first}');
      const channel = MethodChannel(AppConstants.archiveChannel);
      const progressChannel =
          EventChannel('com.questgamemanager.quest_game_manager/archive_progress');

      StreamSubscription? progressSubscription;

      try {
        // Listen to progress events (0.0 to 1.0)
        progressSubscription = progressChannel.receiveBroadcastStream().listen((event) {
          if (event is double) {
            // Map 0.0-1.0 to 0.90-0.98
            final overallProgress = 0.90 + (event * 0.08);
            emit(task.copyWith(
              status: DownloadStatus.extracting,
              pipelineStage: PipelineStage.extracting,
              progress: overallProgress,
            ));
          }
        });

        await channel.invokeMethod<bool>('extract7z', {
          'filePath': archiveFile.path,
          'outDir': downloadDir.path,
          'password': password,
        });

        AppLogger.info('Extraction complete', tag: 'DownloadDS');
      } on PlatformException catch (e) {
        throw ExtractionException(message: 'Extraction failed: ${e.message}');
      } finally {
        await progressSubscription?.cancel();
      }

      // Clean up archive files
      await for (final entity in downloadDir.list()) {
        if (entity is File && entity.path.contains('.7z.')) {
          await entity.delete();
        }
      }

      emit(task.copyWith(
        status: DownloadStatus.extracting,
        pipelineStage: PipelineStage.extracting,
        progress: 0.95,
      ));

      // --- INSTALL PHASE ---
      emit(task.copyWith(
        status: DownloadStatus.installing,
        pipelineStage: PipelineStage.installing,
        progress: 0.96,
      ));

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

      emit(task.copyWith(
        status: DownloadStatus.installing,
        pipelineStage: PipelineStage.copyingObb,
        progress: 0.98,
      ));

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
      emit(task.copyWith(
        pipelineStage: PipelineStage.cleaning,
        progress: 0.99,
      ));

      // Clean up extracted files but keep the dir structure info
      try {
        await downloadDir.delete(recursive: true);
      } catch (e) {
        AppLogger.warning('Cleanup partial: $e', tag: 'DownloadDS');
      }

      emit(task.copyWith(
        status: DownloadStatus.completed,
        pipelineStage: PipelineStage.done,
        progress: 1,
      ));

      await controller.close();
    } catch (e, st) {
      AppLogger.error('Download pipeline failed', tag: 'DownloadDS', error: e, stackTrace: st);
      emit(task.copyWith(status: DownloadStatus.failed));
      await controller.close();
    }
  }

  /// Cancels the current download.
  void cancelDownload() {
    _isCancelled = true;
    _cancelToken?.cancel('User cancelled');
  }

  Future<Directory> _getDownloadBaseDir() async {
    Directory? baseDir;
    if (Platform.isAndroid) {
      baseDir = await getExternalStorageDirectory();
    }
    baseDir ??= await getApplicationSupportDirectory();
    return baseDir;
  }

  /// Returns the total size of the downloads directory in bytes.
  Future<int> getDownloadsSize() async {
    try {
      final baseDir = await _getDownloadBaseDir();
      if (!baseDir.existsSync()) return 0;

      return await FileUtils.getDirectorySize(baseDir);
    } catch (e) {
      AppLogger.error('Failed to calculate downloads size', tag: 'DownloadDS', error: e);
      return 0;
    }
  }

  /// Clears the downloads directory.
  Future<void> clearDownloads() async {
    try {
      if (_cancelToken != null && !_cancelToken!.isCancelled) {
        cancelDownload();
      }

      final baseDir = await _getDownloadBaseDir();
      if (baseDir.existsSync()) {
        await for (final entity in baseDir.list()) {
          await entity.delete(recursive: true);
        }
      }
    } catch (e) {
      AppLogger.error('Failed to clear downloads', tag: 'DownloadDS', error: e);
      throw const DownloadException(message: 'Failed to clear downloads');
    }
  }
}
