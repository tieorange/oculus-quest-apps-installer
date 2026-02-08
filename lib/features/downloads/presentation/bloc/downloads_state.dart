import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quest_game_manager/core/error/failures.dart';
import 'package:quest_game_manager/features/downloads/domain/entities/download_task.dart';

part 'downloads_state.freezed.dart';

/// States for DownloadsBloc.
@freezed
sealed class DownloadsState with _$DownloadsState {
  const factory DownloadsState.initial() = DownloadsInitial;
  const factory DownloadsState.loading() = DownloadsLoading;
  const factory DownloadsState.loaded({
    required List<DownloadTask> queue,
    DownloadTask? currentDownload,
  }) = DownloadsLoaded;
  const factory DownloadsState.error(Failure failure) = DownloadsError;
}

/// Helper extension to get queue from any state.
extension DownloadsStateX on DownloadsState {
  List<DownloadTask> get queue => switch (this) {
        DownloadsLoaded(:final queue) => queue,
        _ => const [],
      };

  int get activeCount => queue.where((t) =>
      t.status == DownloadStatus.downloading ||
      t.status == DownloadStatus.extracting ||
      t.status == DownloadStatus.installing).length;

  int get completedCount =>
      queue.where((t) => t.status == DownloadStatus.completed).length;

  int get queuedCount =>
      queue.where((t) => t.status == DownloadStatus.queued).length;
}
