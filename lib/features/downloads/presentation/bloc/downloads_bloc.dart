import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:quest_game_manager/core/error/failures.dart';
import 'package:quest_game_manager/core/utils/app_logger.dart';
import 'package:quest_game_manager/core/utils/hash_utils.dart';
import 'package:quest_game_manager/features/config/domain/entities/public_config.dart';
import 'package:quest_game_manager/features/config/domain/repositories/config_repository.dart';
import 'package:quest_game_manager/features/downloads/domain/entities/download_task.dart';
import 'package:quest_game_manager/features/downloads/domain/repositories/download_repository.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_event.dart';
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_state.dart';

/// BLoC for managing downloads.
@injectable
class DownloadsBloc extends Bloc<DownloadsEvent, DownloadsState> {
  DownloadsBloc(this._downloadRepository, this._configRepository)
      : super(const DownloadsState.initial()) {
    on<DownloadsLoadQueue>(_onLoadQueue);
    on<DownloadsDownload>(_onDownload);
    on<DownloadsCancel>(_onCancel);
    on<DownloadsRetry>(_onRetry);
    on<DownloadsRemove>(_onRemove);
    on<DownloadsPauseAll>(_onPauseAll);
    on<DownloadsResumeAll>(_onResumeAll);
  }

  final DownloadRepository _downloadRepository;
  final ConfigRepository _configRepository;
  final List<DownloadTask> _queue = [];
  StreamSubscription<DownloadTask>? _downloadSubscription;
  bool _isDownloading = false;

  Future<void> _onLoadQueue(DownloadsLoadQueue event, Emitter<DownloadsState> emit) async {
    // Load any saved queue from storage
    final result = await _downloadRepository.getSavedQueue();
    result.fold(
      (failure) => AppLogger.error('Failed to load queue: $failure', tag: 'DownloadsBloc'),
      (savedQueue) {
        _queue
          ..clear()
          ..addAll(savedQueue);
      },
    );
    emit(DownloadsState.loaded(queue: List.from(_queue)));
  }

  Future<void> _onDownload(DownloadsDownload event, Emitter<DownloadsState> emit) async {
    final gameId = HashUtils.computeGameId(event.game.releaseName);

    // Check if already in queue
    if (_queue.any((t) => t.gameId == gameId)) {
      AppLogger.warning('Game already in queue: ${event.game.name}', tag: 'DownloadsBloc');
      return;
    }

    final task = DownloadTask(game: event.game, gameId: gameId, status: DownloadStatus.queued);
    _queue.add(task);
    emit(DownloadsState.loaded(queue: List.from(_queue)));

    // Persist queue after adding new download
    await _saveQueue();

    // Start processing if not already downloading
    if (!_isDownloading) {
      await _processQueue(emit);
    }
  }

  Future<void> _onCancel(DownloadsCancel event, Emitter<DownloadsState> emit) async {
    await _downloadSubscription?.cancel();
    _downloadSubscription = null;
    await _downloadRepository.cancelDownload(event.gameId);

    _queue.removeWhere((t) => t.gameId == event.gameId);
    _isDownloading = false;
    emit(DownloadsState.loaded(queue: List.from(_queue)));

    // Persist queue after cancellation
    await _saveQueue();

    // Process next in queue
    await _processQueue(emit);
  }

  Future<void> _onRetry(DownloadsRetry event, Emitter<DownloadsState> emit) async {
    final index = _queue.indexWhere((t) => t.gameId == event.gameId);
    if (index != -1) {
      _queue[index] = _queue[index].copyWith(status: DownloadStatus.queued);
      emit(DownloadsState.loaded(queue: List.from(_queue)));

      if (!_isDownloading) {
        await _processQueue(emit);
      }
    }
  }

  Future<void> _onRemove(DownloadsRemove event, Emitter<DownloadsState> emit) async {
    _queue.removeWhere((t) => t.gameId == event.gameId);
    emit(DownloadsState.loaded(queue: List.from(_queue)));

    // Persist queue after removal
    await _saveQueue();
  }

  Future<void> _onPauseAll(DownloadsPauseAll event, Emitter<DownloadsState> emit) async {
    await _downloadSubscription?.cancel();
    _downloadSubscription = null;
    await _downloadRepository.cancelDownload('');
    _isDownloading = false;

    // Mark all downloading tasks as paused
    for (var i = 0; i < _queue.length; i++) {
      if (_queue[i].status == DownloadStatus.downloading) {
        _queue[i] = _queue[i].copyWith(status: DownloadStatus.paused);
      }
    }
    emit(DownloadsState.loaded(queue: List.from(_queue)));
  }

  Future<void> _onResumeAll(DownloadsResumeAll event, Emitter<DownloadsState> emit) async {
    // Mark paused tasks as queued
    for (var i = 0; i < _queue.length; i++) {
      if (_queue[i].status == DownloadStatus.paused) {
        _queue[i] = _queue[i].copyWith(status: DownloadStatus.queued);
      }
    }
    emit(DownloadsState.loaded(queue: List.from(_queue)));

    if (!_isDownloading) {
      await _processQueue(emit);
    }
  }

  Future<void> _processQueue(Emitter<DownloadsState> emit) async {
    // Find next queued task
    final nextTaskIndex = _queue.indexWhere((t) => t.status == DownloadStatus.queued);
    if (nextTaskIndex == -1) {
      _isDownloading = false;
      return;
    }

    _isDownloading = true;
    final task = _queue[nextTaskIndex];

    // Get config for baseUri and password
    final configResult = await _configRepository.fetchConfig();
    final config = configResult.fold(
      (Failure failure) {
        AppLogger.error('Failed to get config: $failure', tag: 'DownloadsBloc');
        _queue[nextTaskIndex] = task.copyWith(status: DownloadStatus.failed);
        emit(DownloadsState.loaded(queue: List.from(_queue)));
        _isDownloading = false;
        return null;
      },
      (PublicConfig c) => c,
    );

    if (config == null) return;

    // Start download stream
    AppLogger.info('Starting download for: ${task.game.name}', tag: 'DownloadsBloc');

    await emit.forEach<DownloadTask>(
      _downloadRepository.downloadGame(task.game, config.baseUri, config.password),
      onData: (updatedTask) {
        AppLogger.debug(
            'Received task update: status=${updatedTask.status}, progress=${updatedTask.progress}',
            tag: 'DownloadsBloc',);

        // Update task in queue
        final idx = _queue.indexWhere((t) => t.gameId == updatedTask.gameId);
        if (idx != -1) {
          _queue[idx] = updatedTask;
        }

        return DownloadsState.loaded(
          queue: List.from(_queue),
          currentDownload: updatedTask,
        );
      },
      onError: (Object error, StackTrace stackTrace) {
        AppLogger.error('Download error in stream',
            tag: 'DownloadsBloc', error: error, stackTrace: stackTrace,);

        final idx = _queue.indexWhere((t) => t.gameId == task.gameId);
        if (idx != -1) {
          _queue[idx] = _queue[idx].copyWith(status: DownloadStatus.failed);
        }

        // Return updated state with failure
        return DownloadsState.loaded(queue: List.from(_queue));
      },
    );

    // After stream completes (successfully or with error handled above)
    // process the next item if we are still "downloading" (meaning stream ended naturally)
    // Note: emit.forEach finishes when stream is done.

    AppLogger.info('Download stream completed for: ${task.game.name}', tag: 'DownloadsBloc');
    _isDownloading = false;

    // We need to trigger the next processQueue.
    // Since emit.forEach is done, we are back in the event handler scope.
    // However, _processQueue is called by _onDownload (async).
    // If we call _processQueue(emit) recursively here, it stays in the same event handler future?
    // Yes, but we should be careful about deep recursion.
    // But practically queue is small.
    // To be safe and follow Bloc pattern, we should probably add an event to process next?
    // Or just call it.

    if (_queue.any((t) => t.status == DownloadStatus.queued)) {
      await _processQueue(emit);
    }
  }

  /// Helper to persist the queue to storage.
  Future<void> _saveQueue() async {
    final result = await _downloadRepository.saveQueue(_queue);
    result.fold(
      (failure) => AppLogger.warning('Failed to save queue: $failure', tag: 'DownloadsBloc'),
      (_) => AppLogger.debug('Queue saved (${_queue.length} tasks)', tag: 'DownloadsBloc'),
    );
  }

  @override
  Future<void> close() async {
    AppLogger.info('DownloadsBloc closing', tag: 'DownloadsBloc');
    await _downloadSubscription?.cancel();
    // Final save on close
    await _saveQueue();
    return super.close();
  }
}
