import 'package:fpdart/fpdart.dart';
import 'package:quest_game_manager/core/error/failures.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';
import 'package:quest_game_manager/features/config/domain/entities/public_config.dart';

/// Repository interface for game catalog operations.
abstract class CatalogRepository {
  Future<Either<Failure, List<Game>>> getGameCatalog(PublicConfig config);
  Future<Either<Failure, List<Game>>> getCachedCatalog();
  Future<Either<Failure, String>> getGameThumbnailPath(String packageName);
}
