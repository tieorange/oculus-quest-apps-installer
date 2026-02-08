import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:quest_game_manager/core/error/failures.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';
import 'package:quest_game_manager/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:quest_game_manager/features/config/domain/entities/public_config.dart';

/// Use case for fetching the game catalog from remote.
@injectable
class GetGameCatalog {
  GetGameCatalog(this._repository);
  final CatalogRepository _repository;

  Future<Either<Failure, List<Game>>> call(PublicConfig config) =>
      _repository.getGameCatalog(config);
}

/// Use case for getting cached catalog.
@injectable
class GetCachedCatalog {
  GetCachedCatalog(this._repository);
  final CatalogRepository _repository;

  Future<Either<Failure, List<Game>>> call() => _repository.getCachedCatalog();
}

/// Use case for checking if cache is stale (> 10 minutes old).
@injectable
class IsCacheStale {
  IsCacheStale(this._repository);
  final CatalogRepository _repository;

  Future<bool> call() => _repository.isCacheStale();
}
