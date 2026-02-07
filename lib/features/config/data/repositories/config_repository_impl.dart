import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:quest_game_manager/core/error/exceptions.dart';
import 'package:quest_game_manager/core/error/failures.dart';
import 'package:quest_game_manager/features/config/data/datasources/config_remote_datasource.dart';
import 'package:quest_game_manager/features/config/domain/entities/public_config.dart';
import 'package:quest_game_manager/features/config/domain/repositories/config_repository.dart';

/// Implementation of ConfigRepository.
@Injectable(as: ConfigRepository)
class ConfigRepositoryImpl implements ConfigRepository {
  ConfigRepositoryImpl(this._remoteDatasource);
  final ConfigRemoteDatasource _remoteDatasource;

  @override
  Future<Either<Failure, PublicConfig>> fetchConfig() async {
    try {
      final model = await _remoteDatasource.fetchConfig();
      return Right(model.toEntity());
    } on NetworkException catch (e) {
      return Left(Failure.network(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}
