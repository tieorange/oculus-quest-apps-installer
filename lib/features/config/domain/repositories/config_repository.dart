import 'package:fpdart/fpdart.dart';
import 'package:quest_game_manager/core/error/failures.dart';
import 'package:quest_game_manager/features/config/domain/entities/public_config.dart';

/// Repository interface for fetching app configuration.
/// Repository interface for fetching app configuration.
// ignore: one_member_abstracts
abstract class ConfigRepository {
  Future<Either<Failure, PublicConfig>> fetchConfig();
  Future<Either<Failure, Unit>> saveConfig(PublicConfig config);
}
