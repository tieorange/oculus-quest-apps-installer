import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';

part 'downloads_event.freezed.dart';

/// Events for DownloadsBloc.
@freezed
sealed class DownloadsEvent with _$DownloadsEvent {
  const factory DownloadsEvent.loadQueue() = DownloadsLoadQueue;
  const factory DownloadsEvent.download(Game game) = DownloadsDownload;
  const factory DownloadsEvent.cancel(String gameId) = DownloadsCancel;
  const factory DownloadsEvent.retry(String gameId) = DownloadsRetry;
  const factory DownloadsEvent.remove(String gameId) = DownloadsRemove;
  const factory DownloadsEvent.pauseAll() = DownloadsPauseAll;
  const factory DownloadsEvent.resumeAll() = DownloadsResumeAll;
}
