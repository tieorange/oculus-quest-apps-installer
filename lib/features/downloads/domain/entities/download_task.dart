import 'package:equatable/equatable.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';

/// Download task entity tracking download progress.
class DownloadTask extends Equatable {
  const DownloadTask({
    required this.game,
    required this.gameId,
    required this.status,
    this.progress = 0,
    this.bytesReceived = 0,
    this.totalBytes = 0,
    this.speedBytesPerSecond = 0,
  });

  final Game game;
  final String gameId;
  final DownloadStatus status;
  final double progress;
  final int bytesReceived;
  final int totalBytes;
  final double speedBytesPerSecond;

  DownloadTask copyWith({
    Game? game,
    String? gameId,
    DownloadStatus? status,
    double? progress,
    int? bytesReceived,
    int? totalBytes,
    double? speedBytesPerSecond,
  }) {
    return DownloadTask(
      game: game ?? this.game,
      gameId: gameId ?? this.gameId,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      bytesReceived: bytesReceived ?? this.bytesReceived,
      totalBytes: totalBytes ?? this.totalBytes,
      speedBytesPerSecond: speedBytesPerSecond ?? this.speedBytesPerSecond,
    );
  }

  @override
  List<Object?> get props => [gameId, status, progress];
}

enum DownloadStatus { queued, downloading, paused, extracting, completed, failed }
