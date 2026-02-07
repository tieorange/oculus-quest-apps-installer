import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:quest_game_manager/core/utils/hash_utils.dart';
import 'package:quest_game_manager/features/downloads/domain/entities/download_task.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_event.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_state.dart';

/// BLoC for managing downloads.
@injectable
class DownloadsBloc extends Bloc<DownloadsEvent, DownloadsState> {
  DownloadsBloc() : super(const DownloadsState.initial()) {
    on<DownloadsLoadQueue>(_onLoadQueue);
    on<DownloadsDownload>(_onDownload);
    on<DownloadsCancel>(_onCancel);
    on<DownloadsRetry>(_onRetry);
    on<DownloadsRemove>(_onRemove);
  }

  final List<DownloadTask> _queue = [];
  StreamSubscription<DownloadTask>? _downloadSubscription;

  Future<void> _onLoadQueue(DownloadsLoadQueue event, Emitter<DownloadsState> emit) async {
    emit(DownloadsState.loaded(queue: List.from(_queue)));
  }

  void _onDownload(DownloadsDownload event, Emitter<DownloadsState> emit) {
    final gameId = HashUtils.computeGameId(event.game.releaseName);
    final task = DownloadTask(game: event.game, gameId: gameId, status: DownloadStatus.queued);
    _queue.add(task);
    emit(DownloadsState.loaded(queue: List.from(_queue)));
    _processQueue(emit);
  }

  void _onCancel(DownloadsCancel event, Emitter<DownloadsState> emit) {
    _queue.removeWhere((t) => t.gameId == event.gameId);
    _downloadSubscription?.cancel();
    emit(DownloadsState.loaded(queue: List.from(_queue)));
  }

  void _onRetry(DownloadsRetry event, Emitter<DownloadsState> emit) {
    final index = _queue.indexWhere((t) => t.gameId == event.gameId);
    if (index != -1) {
      _queue[index] = _queue[index].copyWith(status: DownloadStatus.queued);
      emit(DownloadsState.loaded(queue: List.from(_queue)));
      _processQueue(emit);
    }
  }

  void _onRemove(DownloadsRemove event, Emitter<DownloadsState> emit) {
    _queue.removeWhere((t) => t.gameId == event.gameId);
    emit(DownloadsState.loaded(queue: List.from(_queue)));
  }

  void _processQueue(Emitter<DownloadsState> emit) {
    // Find next queued task
    final nextTaskIndex = _queue.indexWhere((t) => t.status == DownloadStatus.queued);
    if (nextTaskIndex == -1) return;

    // Start download (placeholder - will be implemented with DownloadRepository)
    _queue[nextTaskIndex] = _queue[nextTaskIndex].copyWith(status: DownloadStatus.downloading);
    emit(DownloadsState.loaded(queue: List.from(_queue), currentDownload: _queue[nextTaskIndex]));
  }

  @override
  Future<void> close() {
    _downloadSubscription?.cancel();
    return super.close();
  }
}
