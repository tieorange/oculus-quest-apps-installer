import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
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
    // TODO(anduser): Implement with Hive for persistent queue
    return const Right([]);
  }

  @override
  Future<Either<Failure, void>> saveQueue(List<DownloadTask> queue) async {
    // TODO(anduser): Implement with Hive for persistent queue
    return const Right(null);
  }

  /// Convenience method to compute game ID from release name.
  String computeGameId(String releaseName) {
    return HashUtils.computeGameId(releaseName);
  }
}
