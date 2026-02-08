import 'dart:async';
import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:quest_game_manager/core/constants/app_constants.dart';
import 'package:quest_game_manager/core/error/failures.dart';
import 'package:quest_game_manager/core/utils/app_logger.dart';
import 'package:quest_game_manager/core/utils/hash_utils.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';
import 'package:quest_game_manager/features/downloads/data/datasources/download_remote_datasource.dart';
import 'package:quest_game_manager/features/downloads/domain/entities/download_task.dart';
import 'package:quest_game_manager/features/downloads/domain/repositories/download_repository.dart';

/// Implementation of [DownloadRepository].
@LazySingleton(as: DownloadRepository)
class DownloadRepositoryImpl implements DownloadRepository {
  DownloadRepositoryImpl(this._remoteDatasource);
  final DownloadRemoteDatasource _remoteDatasource;

  @override
  Stream<DownloadTask> downloadGame(Game game, String baseUri, String password) {
    return _remoteDatasource.downloadGame(
      game: game,
      baseUri: baseUri,
      password: password,
    );
  }

  @override
  Future<Either<Failure, void>> cancelDownload(String gameId) async {
    try {
      _remoteDatasource.cancelDownload();
      return const Right(null);
    } catch (e, st) {
      AppLogger.error('Failed to cancel download', tag: 'DownloadRepo', error: e, stackTrace: st);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DownloadTask>>> getSavedQueue() async {
    try {
      final box = await Hive.openBox<String>(AppConstants.downloadQueueBoxName);
      final tasks = <DownloadTask>[];
      for (final key in box.keys) {
        try {
          final jsonStr = box.get(key);
          if (jsonStr == null) continue;
          final map = json.decode(jsonStr) as Map<String, dynamic>;
          final game = Game(
            name: map['gameName'] as String? ?? '',
            releaseName: map['releaseName'] as String? ?? '',
            packageName: map['packageName'] as String? ?? '',
            versionCode: map['versionCode'] as String? ?? '',
            lastUpdated: map['lastUpdated'] as String? ?? '',
            sizeMb: map['sizeMb'] as String? ?? '0',
          );
          final status = DownloadStatus.values.firstWhere(
            (s) => s.name == (map['status'] as String?),
            orElse: () => DownloadStatus.failed,
          );
          // Only restore non-completed/non-active tasks as failed (they were interrupted)
          final restoredStatus = switch (status) {
            DownloadStatus.completed => DownloadStatus.completed,
            DownloadStatus.failed => DownloadStatus.failed,
            _ => DownloadStatus.failed, // interrupted downloads become failed
          };
          tasks.add(DownloadTask(
            game: game,
            gameId: map['gameId'] as String? ?? '',
            status: restoredStatus,
          ),);
        } catch (e) {
          AppLogger.warning('Skipping corrupted queue entry: $key', tag: 'DownloadRepo');
        }
      }
      return Right(tasks);
    } catch (e, st) {
      AppLogger.error('Failed to load queue', tag: 'DownloadRepo', error: e, stackTrace: st);
      return const Right([]); // Non-fatal, just start fresh
    }
  }

  @override
  Future<Either<Failure, void>> saveQueue(List<DownloadTask> queue) async {
    try {
      final box = await Hive.openBox<String>(AppConstants.downloadQueueBoxName);
      await box.clear();
      for (final task in queue) {
        final map = {
          'gameId': task.gameId,
          'gameName': task.game.name,
          'releaseName': task.game.releaseName,
          'packageName': task.game.packageName,
          'versionCode': task.game.versionCode,
          'lastUpdated': task.game.lastUpdated,
          'sizeMb': task.game.sizeMb,
          'status': task.status.name,
        };
        await box.put(task.gameId, json.encode(map));
      }
      return const Right(null);
    } catch (e, st) {
      AppLogger.error('Failed to save queue', tag: 'DownloadRepo', error: e, stackTrace: st);
      return const Left(StorageFailure(message: 'Failed to save download queue'));
    }
  }

  /// Convenience method to compute game ID from release name.
  String computeGameId(String releaseName) {
    return HashUtils.computeGameId(releaseName);
  }
}
