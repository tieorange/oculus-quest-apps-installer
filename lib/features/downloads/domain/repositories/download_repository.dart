import 'package:fpdart/fpdart.dart';
import 'package:quest_game_manager/core/error/failures.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';
import 'package:quest_game_manager/features/downloads/domain/entities/download_task.dart';
import 'package:quest_game_manager/features/downloads/domain/entities/storage_item.dart';

/// Repository interface for download operations.
abstract class DownloadRepository {
  Stream<DownloadTask> downloadGame(Game game, String baseUri, String password);
  Future<Either<Failure, void>> cancelDownload(String gameId);
  Future<Either<Failure, List<DownloadTask>>> getSavedQueue();
  Future<Either<Failure, void>> saveQueue(List<DownloadTask> queue);
  Future<Either<Failure, int>> getDownloadsSize();
  Future<Either<Failure, void>> clearDownloads();
  Future<Either<Failure, List<StorageItem>>> getStorageItems();
  Future<Either<Failure, void>> deleteStorageItems(List<StorageItem> items);
}
