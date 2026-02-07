import 'dart:async';
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
@lazySingleton
class DownloadRemoteDatasource {
  DownloadRemoteDatasource(this._dio);
  final Dio _dio;

  CancelToken? _currentCancelToken;
  static const _userAgent = 'rclone/v1.66.0';

  /// Lists files available for a game on the remote server.
  /// Returns a list of (filename, sizeBytes) tuples.
  Future<List<(String, int)>> listGameFiles({
    required String baseUri,
    required String gameId,
  }) async {
    AppLogger.debug('listGameFiles called for $gameId', tag: 'DownloadDS');
    final url = '${_normalizeBaseUri(baseUri)}$gameId/';
    AppLogger.info('Fetching file list from: $url', tag: 'DownloadDS');

    try {
      final response = await _dio.get<String>(
        url,
        options: Options(
          headers: {
            'User-Agent': _userAgent,
            'Accept': '*/*',
          },
          responseType: ResponseType.plain,
        ),
      );

      final html = response.data ?? '';
      AppLogger.debug('Received HTML response (${html.length} chars)', tag: 'DownloadDS');
      AppLogger.debug('HTML Content: $html', tag: 'DownloadDS');
      return _parseDirectoryListing(html);
    } on DioException catch (e) {
      AppLogger.error('Failed to list game files', tag: 'DownloadDS', error: e);
      throw NetworkException(message: 'Failed to list game files: ${e.message}');
    } catch (e, st) {
      AppLogger.error('Unexpected error in listGameFiles',
          tag: 'DownloadDS', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Parses HTML directory listing from the server.
  /// Format: <pre> block with lines like "filename    date    size"
  List<(String, int)> _parseDirectoryListing(String html) {
    final files = <(String, int)>[];
    // Match files like: a1b2c3d4.7z.001   date   12345
    final regex = RegExp(
      r'(?:\.\.\/)?([0-9a-f]+\.7z\.\d+)\s+.*?\s+(\d+)\s*$',
      multiLine: true,
    );

    for (final match in regex.allMatches(html)) {
      final filename = match.group(1)!;
      final size = int.parse(match.group(2)!);
      files.add((filename, size));
    }

    AppLogger.debug('Found ${files.length} archive parts', tag: 'DownloadDS');
    return files;
  }

  /// Downloads a game and emits progress updates.
  /// Returns a stream of [DownloadTask] with updated progress.
  Stream<DownloadTask> downloadGame({
    required Game game,
    required String baseUri,
    required String password,
  }) async* {
    final gameId = HashUtils.computeGameId(game.releaseName);
    AppLogger.info('Starting download for: ${game.name}', tag: 'DownloadDS');
    AppLogger.debug('Game ID: $gameId', tag: 'DownloadDS');

    final task = DownloadTask(
      game: game,
      gameId: gameId,
      status: DownloadStatus.queued,
    );

    yield task.copyWith(status: DownloadStatus.downloading);

    try {
      // 1. List files
      AppLogger.debug('Calling listGameFiles for gameId: $gameId', tag: 'DownloadDS');
      final files = await listGameFiles(baseUri: baseUri, gameId: gameId);
      AppLogger.debug('listGameFiles returned ${files.length} files', tag: 'DownloadDS');

      if (files.isEmpty) {
        throw const NetworkException(message: 'No files found for game');
      }

      final totalBytes = files.fold<int>(0, (sum, f) => sum + f.$2);
      var downloadedBytes = 0;

      // 2. Prepare cache directory
      final cacheDir = await getApplicationCacheDirectory();
      final downloadDir = Directory('${cacheDir.path}/$gameId');
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      _currentCancelToken = CancelToken();
      final baseUrl = _normalizeBaseUri(baseUri);
      final startTime = DateTime.now();

      // 3. Download each file part
      for (final (filename, fileSize) in files) {
        final url = '$baseUrl$gameId/$filename';
        final filePath = '${downloadDir.path}/$filename';
        final file = File(filePath);

        // Check for resume support
        var startByte = 0;
        if (await file.exists()) {
          startByte = await file.length();
          if (startByte >= fileSize) {
            // File already downloaded
            downloadedBytes += fileSize;
            continue;
          }
          downloadedBytes += startByte;
        }

        AppLogger.debug(
            'Downloading $filename (${startByte > 0 ? "resume from $startByte" : "new"})',
            tag: 'DownloadDS');

        await _dio.download(
          url,
          filePath,
          cancelToken: _currentCancelToken,
          deleteOnError: false,
          options: Options(
            headers: {
              'User-Agent': _userAgent,
              if (startByte > 0) 'Range': 'bytes=$startByte-',
            },
          ),
          onReceiveProgress: (received, total) {
            // Progress is calculated after each file completes
          },
        );

        downloadedBytes += fileSize - startByte;

        final progress = downloadedBytes / totalBytes;
        final elapsed = DateTime.now().difference(startTime).inMilliseconds;
        final speed = elapsed > 0 ? (downloadedBytes / elapsed) * 1000 : 0.0;

        yield task.copyWith(
          status: DownloadStatus.downloading,
          progress: progress,
          bytesReceived: downloadedBytes,
          totalBytes: totalBytes,
          speedBytesPerSecond: speed,
        );
      }

      // 4. Extraction phase
      yield task.copyWith(
        status: DownloadStatus.extracting,
        progress: 1.0,
        bytesReceived: totalBytes,
        totalBytes: totalBytes,
      );

      // Find the first .7z.001 file
      final archiveFile = files.firstWhere((f) => f.$1.endsWith('.7z.001'));
      final archivePath = '${downloadDir.path}/${archiveFile.$1}';
      final dataDir = await getApplicationDocumentsDirectory();

      await _extract7z(archivePath, dataDir.path, password);

      yield task.copyWith(
        status: DownloadStatus.completed,
        progress: 1.0,
        bytesReceived: totalBytes,
        totalBytes: totalBytes,
      );

      // 5. Cleanup archive files
      try {
        await downloadDir.delete(recursive: true);
        AppLogger.info('Cleaned up download cache', tag: 'DownloadDS');
      } catch (e) {
        AppLogger.warning('Failed to cleanup cache: $e', tag: 'DownloadDS');
      }
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        yield task.copyWith(status: DownloadStatus.paused);
      } else {
        AppLogger.error('Download failed', tag: 'DownloadDS', error: e);
        yield task.copyWith(status: DownloadStatus.failed);
      }
    } catch (e, st) {
      AppLogger.error('Download failed', tag: 'DownloadDS', error: e, stackTrace: st);
      yield task.copyWith(status: DownloadStatus.failed);
    }
  }

  /// Cancels the current download.
  void cancelDownload() {
    _currentCancelToken?.cancel('User cancelled');
    _currentCancelToken = null;
  }

  /// Extracts a 7z archive using native channel.
  Future<void> _extract7z(String archivePath, String outDir, String password) async {
    AppLogger.info('Extracting archive: $archivePath', tag: 'DownloadDS');

    const channel = MethodChannel('com.questgamemanager.quest_game_manager/archive');
    try {
      await channel.invokeMethod<bool>('extract7z', {
        'filePath': archivePath,
        'outDir': outDir,
        'password': password,
      });
      AppLogger.info('Extraction complete', tag: 'DownloadDS');
    } catch (e) {
      AppLogger.error('Extraction failed: $e', tag: 'DownloadDS');
      throw ExtractionException(message: 'Failed to extract archive: $e');
    }
  }

  String _normalizeBaseUri(String uri) {
    return uri.endsWith('/') ? uri : '$uri/';
  }
}
