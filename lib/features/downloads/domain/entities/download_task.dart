import 'package:equatable/equatable.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';

/// Download task entity tracking download and install progress.
class DownloadTask extends Equatable {
  const DownloadTask({
    required this.game,
    required this.gameId,
    required this.status,
    this.progress = 0,
    this.bytesReceived = 0,
    this.totalBytes = 0,
    this.speedBytesPerSecond = 0,
    this.currentPart = 0,
    this.totalParts = 0,
    this.pipelineStage = PipelineStage.downloading,
  });

  final Game game;
  final String gameId;
  final DownloadStatus status;
  final double progress;
  final int bytesReceived;
  final int totalBytes;
  final double speedBytesPerSecond;
  final int currentPart;
  final int totalParts;
  final PipelineStage pipelineStage;

  DownloadTask copyWith({
    Game? game,
    String? gameId,
    DownloadStatus? status,
    double? progress,
    int? bytesReceived,
    int? totalBytes,
    double? speedBytesPerSecond,
    int? currentPart,
    int? totalParts,
    PipelineStage? pipelineStage,
  }) {
    return DownloadTask(
      game: game ?? this.game,
      gameId: gameId ?? this.gameId,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      bytesReceived: bytesReceived ?? this.bytesReceived,
      totalBytes: totalBytes ?? this.totalBytes,
      speedBytesPerSecond: speedBytesPerSecond ?? this.speedBytesPerSecond,
      currentPart: currentPart ?? this.currentPart,
      totalParts: totalParts ?? this.totalParts,
      pipelineStage: pipelineStage ?? this.pipelineStage,
    );
  }

  @override
  List<Object?> get props => [gameId, status, progress, pipelineStage];
}

enum DownloadStatus { queued, downloading, paused, extracting, installing, completed, failed }

enum PipelineStage { downloading, extracting, installing, copyingObb, cleaning, done }
