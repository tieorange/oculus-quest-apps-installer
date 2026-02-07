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
