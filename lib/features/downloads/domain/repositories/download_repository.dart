import 'package:fpdart/fpdart.dart';
import 'package:quest_game_manager/core/error/failures.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';
import 'package:quest_game_manager/features/downloads/domain/entities/download_task.dart';

/// Repository interface for download operations.
abstract class DownloadRepository {
  Future<Either<Failure, List<(String filename, int sizeBytes)>>> listGameFiles(
    String baseUri,
    String gameId,
  );
  Stream<DownloadTask> downloadGame(Game game, String baseUri, String password);
  Future<Either<Failure, void>> cancelDownload(String gameId);
  Future<Either<Failure, List<DownloadTask>>> getSavedQueue();
  Future<Either<Failure, void>> saveQueue(List<DownloadTask> queue);
}
