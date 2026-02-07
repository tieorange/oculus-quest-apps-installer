import 'dart:io';

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
}
