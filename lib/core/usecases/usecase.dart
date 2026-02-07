import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:quest_game_manager/core/error/failures.dart';

/// Base class for all use cases.
/// Base class for all use cases.
// ignore: one_member_abstracts
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();
  @override
  List<Object?> get props => [];
}
