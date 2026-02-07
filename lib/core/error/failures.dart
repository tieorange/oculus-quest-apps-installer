import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Sealed class representing all possible failure types.
@freezed
sealed class Failure with _$Failure {
  const Failure._();
  const factory Failure.network({required String message}) = NetworkFailure;
  const factory Failure.server({required int statusCode, required String message}) = ServerFailure;
  const factory Failure.storage({required String message}) = StorageFailure;
  const factory Failure.extraction({required String message}) = ExtractionFailure;
  const factory Failure.installation({required String message}) = InstallationFailure;
  const factory Failure.permission({required String permission}) = PermissionFailure;
  const factory Failure.insufficientSpace({required int requiredMb, required int availableMb}) =
      InsufficientSpaceFailure;
  const factory Failure.cancelled() = CancelledFailure;
  const factory Failure.unknown({required String message}) = UnknownFailure;

  String get userMessage => switch (this) {
        NetworkFailure(:final message) => 'Network error: $message',
        ServerFailure(:final statusCode, :final message) => 'Server error ($statusCode): $message',
        StorageFailure(:final message) => 'Storage error: $message',
        ExtractionFailure(:final message) => 'Extraction failed: $message',
        InstallationFailure(:final message) => 'Installation failed: $message',
        PermissionFailure(:final permission) => 'Permission required: $permission',
        InsufficientSpaceFailure(:final requiredMb, :final availableMb) =>
          'Need ${requiredMb}MB but only ${availableMb}MB available',
        CancelledFailure() => 'Operation cancelled',
        UnknownFailure(:final message) => 'Error: $message',
      };
}

extension FailureX on Failure {
  String get userMessage => switch (this) {
        NetworkFailure(:final message) => 'Network error: $message',
        ServerFailure(:final statusCode, :final message) => 'Server error ($statusCode): $message',
        StorageFailure(:final message) => 'Storage error: $message',
        ExtractionFailure(:final message) => 'Extraction failed: $message',
        InstallationFailure(:final message) => 'Installation failed: $message',
        PermissionFailure(:final permission) => 'Permission required: $permission',
        InsufficientSpaceFailure(:final requiredMb, :final availableMb) =>
          'Need ${requiredMb}MB but only ${availableMb}MB available',
        CancelledFailure() => 'Operation cancelled',
        UnknownFailure(:final message) => 'Error: $message',
      };
}
