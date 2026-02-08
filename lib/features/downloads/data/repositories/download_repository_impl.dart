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
import 'package:quest_game_manager/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:quest_game_manager/features/downloads/data/datasources/download_remote_datasource.dart';
import 'package:quest_game_manager/features/downloads/domain/entities/download_task.dart';
import 'package:quest_game_manager/features/downloads/domain/entities/storage_item.dart';
import 'package:quest_game_manager/features/downloads/domain/repositories/download_repository.dart';

/// Implementation of [DownloadRepository].
@LazySingleton(as: DownloadRepository)
class DownloadRepositoryImpl implements DownloadRepository {
  DownloadRepositoryImpl(this._remoteDatasource, this._catalogRepository);
  final DownloadRemoteDatasource _remoteDatasource;
  final CatalogRepository _catalogRepository;

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
          tasks.add(
            DownloadTask(
              game: game,
              gameId: map['gameId'] as String? ?? '',
              status: restoredStatus,
            ),
          );
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

  @override
  Future<Either<Failure, int>> getDownloadsSize() async {
    try {
      final size = await _remoteDatasource.getDownloadsSize();
      return Right(size);
    } catch (e, st) {
      AppLogger.error('Failed to get downloads size',
          tag: 'DownloadRepo', error: e, stackTrace: st);
      return Left(StorageFailure(message: 'Failed to get downloads size'));
    }
  }

  @override
  Future<Either<Failure, void>> clearDownloads() async {
    try {
      await _remoteDatasource.clearDownloads();
      return const Right(null);
    } catch (e, st) {
      AppLogger.error('Failed to clear downloads', tag: 'DownloadRepo', error: e, stackTrace: st);
      return Left(StorageFailure(message: 'Failed to clear downloads'));
    }
  }

  @override
  Future<Either<Failure, List<StorageItem>>> getStorageItems() async {
    try {
      final items = <StorageItem>[];

      // Get catalog for matching
      final catalogResult = await _catalogRepository.getCachedCatalog();
      final games = catalogResult.getOrElse((_) => <Game>[]);

      // Build lookup maps
      final gameIdToGame = <String, Game>{};
      final packageToGame = <String, Game>{};
      for (final game in games) {
        gameIdToGame[HashUtils.computeGameId(game.releaseName)] = game;
        packageToGame[game.packageName] = game;
      }

      // Get download cache folders
      final downloadFolders = await _remoteDatasource.getDownloadFolders();
      for (final folder in downloadFolders) {
        final game = gameIdToGame[folder.name];
        items.add(StorageItem(
          id: 'dl_${folder.name}',
          label: game?.name ?? folder.name,
          sizeBytes: folder.sizeBytes,
          path: folder.path,
          type: StorageItemType.installer,
          game: game,
        ));
      }

      // Get OBB folders
      final obbFolders = await _remoteDatasource.getObbFolders();
      for (final folder in obbFolders) {
        final game = packageToGame[folder.name];
        items.add(StorageItem(
          id: 'obb_${folder.name}',
          label: game?.name ?? folder.name,
          sizeBytes: folder.sizeBytes,
          path: folder.path,
          type: StorageItemType.obb,
          game: game,
        ));
      }

      // Sort by size descending
      items.sort((a, b) => b.sizeBytes.compareTo(a.sizeBytes));

      return Right(items);
    } catch (e, st) {
      AppLogger.error('Failed to get storage items', tag: 'DownloadRepo', error: e, stackTrace: st);
      return Left(StorageFailure(message: 'Failed to get storage items'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStorageItems(List<StorageItem> items) async {
    try {
      for (final item in items) {
        await _remoteDatasource.deletePath(item.path);
      }
      return const Right(null);
    } catch (e, st) {
      AppLogger.error('Failed to delete storage items',
          tag: 'DownloadRepo', error: e, stackTrace: st);
      return Left(StorageFailure(message: 'Failed to delete some items'));
    }
  }

  /// Convenience method to compute game ID from release name.
  String computeGameId(String releaseName) {
    return HashUtils.computeGameId(releaseName);
  }
}
