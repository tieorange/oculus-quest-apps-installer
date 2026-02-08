import 'package:fpdart/fpdart.dart';
import 'package:quest_game_manager/core/error/failures.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';
import 'package:quest_game_manager/features/config/domain/entities/public_config.dart';

/// Cache TTL in minutes for stale-while-revalidate pattern.
const int kCacheTtlMinutes = 10;

/// Repository interface for game catalog operations.
abstract class CatalogRepository {
  /// Fetches catalog from remote and caches it.
  Future<Either<Failure, List<Game>>> getGameCatalog(PublicConfig config);

  /// Returns cached catalog (may be empty).
  Future<Either<Failure, List<Game>>> getCachedCatalog();

  /// Returns the timestamp when cache was last updated, or null if no cache.
  Future<DateTime?> getCacheAge();

  /// Returns true if cache is stale (> 10 minutes old) or doesn't exist.
  Future<bool> isCacheStale();

  Future<Either<Failure, String>> getGameThumbnailPath(String packageName);
}
