import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:quest_game_manager/core/error/exceptions.dart';
import 'package:quest_game_manager/core/error/failures.dart';
import 'package:quest_game_manager/core/utils/app_logger.dart';
import 'package:quest_game_manager/features/catalog/data/datasources/catalog_local_datasource.dart';
import 'package:quest_game_manager/features/catalog/data/datasources/catalog_remote_datasource.dart';
import 'package:quest_game_manager/features/catalog/domain/entities/game.dart';
import 'package:quest_game_manager/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:quest_game_manager/features/config/domain/entities/public_config.dart';

/// Implementation of CatalogRepository.
@Injectable(as: CatalogRepository)
class CatalogRepositoryImpl implements CatalogRepository {
  CatalogRepositoryImpl(this._remoteDatasource, this._localDatasource);

  final CatalogRemoteDatasource _remoteDatasource;
  final CatalogLocalDatasource _localDatasource;

  @override
  Future<Either<Failure, List<Game>>> getGameCatalog(PublicConfig config) async {
    AppLogger.info('Fetching game catalog from remote', tag: 'CatalogRepo');
    try {
      final models = await _remoteDatasource.fetchCatalog(config);
      AppLogger.info('Fetched ${models.length} games, caching...', tag: 'CatalogRepo');
      await _localDatasource.cacheGames(models);
      AppLogger.info('Catalog cached successfully', tag: 'CatalogRepo');
      return Right(models.map((m) => m.toEntity()).toList());
    } on NetworkException catch (e, st) {
      AppLogger.error(
        'Network error fetching catalog',
        tag: 'CatalogRepo',
        error: e,
        stackTrace: st,
      );
      return Left(Failure.network(message: e.message));
    } on ExtractionException catch (e, st) {
      AppLogger.error(
        'Extraction error',
        tag: 'CatalogRepo',
        error: e,
        stackTrace: st,
      );
      return Left(Failure.extraction(message: e.message));
    } on StorageException catch (e, st) {
      AppLogger.error(
        'Storage error',
        tag: 'CatalogRepo',
        error: e,
        stackTrace: st,
      );
      return Left(Failure.storage(message: e.message));
    } catch (e, st) {
      AppLogger.error(
        'Unknown error fetching catalog',
        tag: 'CatalogRepo',
        error: e,
        stackTrace: st,
      );
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Game>>> getCachedCatalog() async {
    try {
      final models = await _localDatasource.getCachedGames();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getGameThumbnailPath(String packageName) async {
    try {
      final path = await _remoteDatasource.getThumbnailPath(packageName);
      if (path != null) {
        return Right(path);
      }
      return const Left(Failure.storage(message: 'Thumbnail not found'));
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }
}
