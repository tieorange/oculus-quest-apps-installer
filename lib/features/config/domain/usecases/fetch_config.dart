import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:quest_game_manager/core/error/failures.dart';
import 'package:quest_game_manager/core/usecases/usecase.dart';
import 'package:quest_game_manager/features/config/domain/entities/public_config.dart';
import 'package:quest_game_manager/features/config/domain/repositories/config_repository.dart';

/// Use case for fetching public config.
@injectable
class FetchConfig implements UseCase<PublicConfig, NoParams> {
  FetchConfig(this._repository);
  final ConfigRepository _repository;

  @override
  Future<Either<Failure, PublicConfig>> call(NoParams params) => _repository.fetchConfig();
}
