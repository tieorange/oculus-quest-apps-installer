import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:quest_game_manager/core/error/exceptions.dart';
import 'package:quest_game_manager/core/error/failures.dart';
import 'package:quest_game_manager/core/utils/app_logger.dart';
import 'package:quest_game_manager/features/config/data/datasources/config_local_datasource.dart';
import 'package:quest_game_manager/features/config/data/datasources/config_remote_datasource.dart';
import 'package:quest_game_manager/features/config/data/models/public_config_model.dart';
import 'package:quest_game_manager/features/config/domain/entities/public_config.dart';
import 'package:quest_game_manager/features/config/domain/repositories/config_repository.dart';

/// Implementation of ConfigRepository.
@LazySingleton(as: ConfigRepository)
class ConfigRepositoryImpl implements ConfigRepository {
  ConfigRepositoryImpl(
    this._remoteDatasource,
    this._localDatasource,
  );

  final ConfigRemoteDatasource _remoteDatasource;
  final ConfigLocalDatasource _localDatasource;

  @override
  Future<Either<Failure, PublicConfig>> fetchConfig() async {
    try {
      // 1. Try local config first
      try {
        final localConfig = await _localDatasource.getConfig();
        if (localConfig != null) {
          AppLogger.info('Using local config', tag: 'ConfigRepo');
          return Right(localConfig.toEntity());
        }
      } catch (e) {
        AppLogger.warning('Failed to load local config, falling back to remote', tag: 'ConfigRepo');
      }

      // 2. Fetch from remote
      final remoteConfig = await _remoteDatasource.fetchConfig();

      // 3. Save to local storage
      try {
        await _localDatasource.saveConfig(remoteConfig);
      } catch (e) {
        AppLogger.warning('Failed to save config locally', tag: 'ConfigRepo');
      }

      return Right(remoteConfig.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveConfig(PublicConfig config) async {
    try {
      // Convert entity to model (encode password back to base64)
      final passwordBase64 = base64Encode(utf8.encode(config.password));
      final model = PublicConfigModel(
        baseUri: config.baseUri,
        password: passwordBase64,
      );

      await _localDatasource.saveConfig(model);
      return const Right(unit);
    } catch (e) {
      return Left(StorageFailure(message: e.toString()));
    }
  }
}
