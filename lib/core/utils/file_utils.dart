import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Utility functions for file system operations.
class FileUtils {
  FileUtils._();

  static Future<int> getFreeSpaceMb(String path) async {
    try {
      final result = await Process.run('df', [path]);
      if (result.exitCode == 0) {
        final lines = (result.stdout as String).split('\n');
        if (lines.length > 1) {
          final parts = lines[1].split(RegExp(r'\s+'));
          if (parts.length >= 4) {
            final availableKb = int.tryParse(parts[3]) ?? 0;
            return availableKb ~/ 1024;
          }
        }
      }
      return -1;
    } catch (_) {
      return -1;
    }
  }

  static Future<bool> hasEnoughSpace(String path, int requiredMb, {double multiplier = 2.5}) async {
    final available = await getFreeSpaceMb(path);
    if (available < 0) return true;
    return available >= (requiredMb * multiplier);
  }

  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  static String formatMb(int mb) {
    if (mb >= 1024) return '${(mb / 1024).toStringAsFixed(1)} GB';
    return '$mb MB';
  }

  static String formatSpeed(double bytesPerSecond) {
    if (bytesPerSecond < 1024) return '${bytesPerSecond.toStringAsFixed(0)} B/s';
    if (bytesPerSecond < 1024 * 1024) {
      return '${(bytesPerSecond / 1024).toStringAsFixed(1)} KB/s';
    }
    return '${(bytesPerSecond / (1024 * 1024)).toStringAsFixed(1)} MB/s';
  }

  static String formatEta(int bytesRemaining, double bytesPerSecond) {
    if (bytesPerSecond <= 0) return '--:--';
    final seconds = (bytesRemaining / bytesPerSecond).round();
    if (seconds < 60) return '${seconds}s';
    if (seconds < 3600) return '${seconds ~/ 60}m ${seconds % 60}s';
    return '${seconds ~/ 3600}h ${(seconds % 3600) ~/ 60}m';
  }

  /// Returns the total cache size in bytes.
  static Future<int> getCacheSize() async {
    try {
      final cacheDir = await getApplicationCacheDirectory();
      return _directorySize(cacheDir);
    } catch (_) {
      return 0;
    }
  }

  static Future<int> _directorySize(Directory dir) async {
    var size = 0;
    if (!dir.existsSync()) return 0;
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        size += await entity.length();
      }
    }
    return size;
  }

  /// Clears the application cache directory.
  static Future<void> clearCache() async {
    final cacheDir = await getApplicationCacheDirectory();
    if (cacheDir.existsSync()) {
      await for (final entity in cacheDir.list()) {
        await entity.delete(recursive: true);
      }
    }
  }
}
