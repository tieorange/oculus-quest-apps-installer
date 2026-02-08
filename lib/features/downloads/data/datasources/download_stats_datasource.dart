import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:quest_game_manager/core/constants/app_constants.dart';

/// Tracks download statistics using Hive.
@lazySingleton
class DownloadStatsDatasource {
  Box<dynamic>? _box;

  Future<Box<dynamic>> get _statsBox async {
    _box ??= await Hive.openBox(AppConstants.downloadStatsBoxName);
    return _box!;
  }

  Future<void> recordDownload({
    required String gameName,
    required int bytesDownloaded,
    required Duration duration,
  }) async {
    final box = await _statsBox;

    // Update totals
    final totalBytes = (box.get('totalBytes') as int?) ?? 0;
    final totalGames = (box.get('totalGames') as int?) ?? 0;
    final totalDurationMs = (box.get('totalDurationMs') as int?) ?? 0;

    await box.put('totalBytes', totalBytes + bytesDownloaded);
    await box.put('totalGames', totalGames + 1);
    await box.put('totalDurationMs', totalDurationMs + duration.inMilliseconds);

    // Update session stats
    final sessionBytes = (box.get('sessionBytes') as int?) ?? 0;
    final sessionGames = (box.get('sessionGames') as int?) ?? 0;
    await box.put('sessionBytes', sessionBytes + bytesDownloaded);
    await box.put('sessionGames', sessionGames + 1);

    // Track peak speed
    if (duration.inSeconds > 0) {
      final speed = bytesDownloaded / duration.inSeconds;
      final peakSpeed = (box.get('peakSpeed') as double?) ?? 0.0;
      if (speed > peakSpeed) {
        await box.put('peakSpeed', speed);
      }
    }
  }

  Future<DownloadStats> getStats() async {
    final box = await _statsBox;
    return DownloadStats(
      totalBytesDownloaded: (box.get('totalBytes') as int?) ?? 0,
      totalGamesInstalled: (box.get('totalGames') as int?) ?? 0,
      totalDuration: Duration(milliseconds: (box.get('totalDurationMs') as int?) ?? 0),
      sessionBytesDownloaded: (box.get('sessionBytes') as int?) ?? 0,
      sessionGamesInstalled: (box.get('sessionGames') as int?) ?? 0,
      peakSpeedBytesPerSec: (box.get('peakSpeed') as double?) ?? 0.0,
    );
  }

  Future<void> resetSession() async {
    final box = await _statsBox;
    await box.put('sessionBytes', 0);
    await box.put('sessionGames', 0);
  }
}

class DownloadStats {
  const DownloadStats({
    required this.totalBytesDownloaded,
    required this.totalGamesInstalled,
    required this.totalDuration,
    required this.sessionBytesDownloaded,
    required this.sessionGamesInstalled,
    required this.peakSpeedBytesPerSec,
  });

  final int totalBytesDownloaded;
  final int totalGamesInstalled;
  final Duration totalDuration;
  final int sessionBytesDownloaded;
  final int sessionGamesInstalled;
  final double peakSpeedBytesPerSec;

  double get averageSpeedBytesPerSec {
    if (totalDuration.inSeconds == 0) return 0;
    return totalBytesDownloaded / totalDuration.inSeconds;
  }

  String get totalFormatted => _formatBytes(totalBytesDownloaded);
  String get sessionFormatted => _formatBytes(sessionBytesDownloaded);
  String get avgSpeedFormatted => '${_formatBytes(averageSpeedBytesPerSec.round())}/s';
  String get peakSpeedFormatted => '${_formatBytes(peakSpeedBytesPerSec.round())}/s';

  static String _formatBytes(int bytes) {
    if (bytes >= 1073741824) return '${(bytes / 1073741824).toStringAsFixed(1)} GB';
    if (bytes >= 1048576) return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    if (bytes >= 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '$bytes B';
  }
}
