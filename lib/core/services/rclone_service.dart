import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quest_game_manager/core/utils/app_logger.dart';

/// Progress update from rclone remote control API.
class RcloneProgress {
  const RcloneProgress({
    required this.bytesTransferred,
    required this.totalBytes,
    required this.speedBytesPerSec,
    required this.eta,
    this.currentFile,
  });

  final int bytesTransferred;
  final int totalBytes;
  final double speedBytesPerSec;
  final Duration eta;
  final String? currentFile;

  double get progress => totalBytes > 0 ? bytesTransferred / totalBytes : 0;
}

/// Service for executing rclone binary commands on Android.
///
/// Rclone is bundled as a native library (librclone.so) in jniLibs.
/// Uses the same command structure as VRPirates/rookie.
@lazySingleton
class RcloneService {
  Process? _currentProcess;
  String? _binaryPath;
  String? _homeDir;

  static const _rcPort = 5572;
  static const _channel = MethodChannel('com.questgamemanager.quest_game_manager/rclone');

  /// Prepares the environment for rclone execution on Android.
  Future<void> _prepareEnvironment() async {
    if (_homeDir != null) return;

    try {
      final appDir = await getApplicationDocumentsDirectory();
      _homeDir = appDir.path;

      // Create empty rclone config file
      final configFile = File('${appDir.path}/rclone.conf');
      if (!configFile.existsSync()) {
        configFile.writeAsStringSync('# rclone config\n');
      }

      AppLogger.info('Environment prepared, HOME: $_homeDir', tag: 'RcloneService');
    } catch (e, st) {
      AppLogger.error(
        'Failed to prepare environment',
        tag: 'RcloneService',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// Resolves hostname to IP using Flutter's network stack (which uses Android's DNS).
  /// This bypasses Go's broken DNS resolution on Android.
  Future<String> _resolveHostToIp(String hostname) async {
    try {
      AppLogger.debug('Resolving hostname: $hostname', tag: 'RcloneService');
      final addresses = await InternetAddress.lookup(hostname);
      if (addresses.isEmpty) {
        throw StateError('Could not resolve hostname: $hostname');
      }
      final ip = addresses.first.address;
      AppLogger.info('Resolved $hostname -> $ip', tag: 'RcloneService');
      return ip;
    } catch (e, st) {
      AppLogger.error(
        'DNS resolution failed for $hostname',
        tag: 'RcloneService',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// Gets the path to the rclone binary from native library directory.
  /// On Android, native libs are installed to a special executable directory.
  Future<String> _getRclonePath() async {
    if (_binaryPath != null) return _binaryPath!;

    try {
      // Get native library directory from Android
      final nativeLibDir = await _channel.invokeMethod<String>('getNativeLibraryDir');
      if (nativeLibDir == null) {
        throw StateError('Failed to get native library directory');
      }

      _binaryPath = '$nativeLibDir/librclone.so';
      AppLogger.info('Rclone binary path: $_binaryPath', tag: 'RcloneService');

      // Verify the file exists
      final file = File(_binaryPath!);
      if (!file.existsSync()) {
        throw StateError('Rclone binary not found at: $_binaryPath');
      }

      return _binaryPath!;
    } catch (e, st) {
      AppLogger.error('Failed to get rclone path', tag: 'RcloneService', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Downloads files from HTTP remote using rclone.
  ///
  /// Uses the same command structure as VRPirates/rookie:
  /// `rclone copy ":http:/{gameHash}/" "{destDir}" --http-url {baseUri} ...`
  Stream<RcloneProgress> download({
    required String baseUri,
    required String gameHash,
    required String destDir,
  }) async* {
    await _prepareEnvironment();
    final binaryPath = await _getRclonePath();

    // Parse the base URI and resolve hostname to IP using Flutter's DNS
    // This bypasses Go's broken DNS resolution on Android
    final uri = Uri.parse(baseUri);
    final resolvedIp = await _resolveHostToIp(uri.host);

    // Construct URL with IP instead of hostname
    final resolvedUri = uri.replace(host: resolvedIp).toString();
    AppLogger.info('Using resolved URI: $resolvedUri', tag: 'RcloneService');

    final configPath = '$_homeDir/rclone.conf';

    // Build rclone command with same flags as rookie
    // We add --no-check-certificate because we're using IP instead of hostname
    // and the SSL cert won't match the IP
    final args = [
      'copy',
      ':http:/$gameHash/',
      destDir,
      '--http-url', resolvedUri,
      '--config', configPath,
      // rclone uses comma-separated key,value format for headers
      '--http-headers', 'Host,${uri.host}', // Pass original host header
      '--no-check-certificate', // IP won't match SSL cert
      '--tpslimit', '1.0',
      '--tpslimit-burst', '3',
      '--inplace',
      '--progress',
      '--rc',
      '--rc-addr', '127.0.0.1:$_rcPort',
      '--rc-no-auth',
      '--transfers', '1',
      '--checkers', '1',
      '--retries', '3',
      '--low-level-retries', '10',
      '-vv', // Very verbose output for debugging
    ];

    // Environment variables for Go runtime
    final environment = <String, String>{
      'HOME': _homeDir!,
      'RCLONE_CONFIG': configPath,
    };

    AppLogger.info('Starting rclone: ${args.join(' ')}', tag: 'RcloneService');
    AppLogger.debug('Binary path: $binaryPath', tag: 'RcloneService');
    AppLogger.debug('Environment: $environment', tag: 'RcloneService');

    try {
      _currentProcess = await Process.start(
        binaryPath,
        args,
        workingDirectory: destDir,
        environment: environment,
      );

      AppLogger.debug('Rclone started, PID: ${_currentProcess!.pid}', tag: 'RcloneService');

      // Listen to stderr for progress info (rclone outputs progress to stderr)
      final stderrSub = _currentProcess!.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) {
        if (line.isNotEmpty) {
          AppLogger.debug('rclone: $line', tag: 'RcloneService');
        }
      });

      // Listen to stdout
      final stdoutSub = _currentProcess!.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) {
        if (line.isNotEmpty) {
          AppLogger.debug('rclone out: $line', tag: 'RcloneService');
        }
      });

      // Poll RC API for progress
      final httpClient = HttpClient();
      var lastProgress = const RcloneProgress(
        bytesTransferred: 0,
        totalBytes: 0,
        speedBytesPerSec: 0,
        eta: Duration.zero,
      );

      // Give rclone time to start
      await Future<void>.delayed(const Duration(milliseconds: 500));

      while (_currentProcess != null) {
        try {
          final stats = await _fetchRcStats(httpClient);
          if (stats != null) {
            lastProgress = stats;
            yield stats;
          }
        } catch (e) {
          // RC API might not be ready yet, ignore
          AppLogger.debug('RC stats fetch failed: $e', tag: 'RcloneService');
        }

        await Future<void>.delayed(const Duration(milliseconds: 200));

        // Check if process has exited
        final exitCode = await _currentProcess?.exitCode.timeout(
          Duration.zero,
          onTimeout: () => -1,
        );
        if (exitCode != null && exitCode != -1) {
          AppLogger.info('Rclone exited with code: $exitCode', tag: 'RcloneService');
          break;
        }
      }

      // Wait for process to complete
      final exitCode = await _currentProcess!.exitCode;
      await stderrSub.cancel();
      await stdoutSub.cancel();
      httpClient.close();

      if (exitCode != 0) {
        throw Exception('Rclone failed with exit code: $exitCode');
      }

      // Emit final 100% progress
      if (lastProgress.totalBytes > 0) {
        yield RcloneProgress(
          bytesTransferred: lastProgress.totalBytes,
          totalBytes: lastProgress.totalBytes,
          speedBytesPerSec: 0,
          eta: Duration.zero,
        );
      }

      AppLogger.info('Rclone download complete', tag: 'RcloneService');
    } finally {
      _currentProcess = null;
    }
  }

  /// Fetches stats from rclone RC API.
  Future<RcloneProgress?> _fetchRcStats(HttpClient client) async {
    try {
      final request = await client.post('127.0.0.1', _rcPort, '/core/stats');
      request.headers.contentType = ContentType.json;
      final response = await request.close();

      if (response.statusCode != 200) return null;

      final body = await response.transform(utf8.decoder).join();
      final json = jsonDecode(body) as Map<String, dynamic>;

      final bytes = (json['bytes'] as num?)?.toInt() ?? 0;
      final totalBytes = (json['totalBytes'] as num?)?.toInt() ?? 0;
      final speed = (json['speed'] as num?)?.toDouble() ?? 0;
      final etaSeconds = (json['eta'] as num?)?.toInt() ?? 0;

      return RcloneProgress(
        bytesTransferred: bytes,
        totalBytes: totalBytes,
        speedBytesPerSec: speed,
        eta: Duration(seconds: etaSeconds),
      );
    } catch (e) {
      return null;
    }
  }

  /// Cancels the current download.
  void cancel() {
    if (_currentProcess != null) {
      AppLogger.info('Cancelling rclone process', tag: 'RcloneService');
      _currentProcess!.kill();
      _currentProcess = null;
    }
  }

  /// Cleans up any running rclone processes.
  Future<void> dispose() async {
    cancel();
  }
}
