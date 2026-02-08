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

  /// User-friendly error message for display.
  String get userMessage => switch (this) {
        NetworkFailure(:final message) =>
          message.contains('SocketException') || message.contains('connection')
              ? 'No internet connection — check your WiFi'
              : 'Network error: $message',
        ServerFailure(:final statusCode, :final message) => switch (statusCode) {
            403 => 'Access denied — the server blocked this request',
            404 => 'Content not found on the server',
            429 => 'Server is busy — try again in a few minutes',
            >= 500 => 'Server is having issues — try again later',
            _ => 'Server error ($statusCode): $message',
          },
        StorageFailure(:final message) => 'Storage error: $message',
        ExtractionFailure(:final message) => 'Extraction failed: $message',
        InstallationFailure(:final message) => 'Installation failed: $message',
        PermissionFailure(:final permission) =>
          'Permission required: $permission\nPlease grant it in Settings',
        InsufficientSpaceFailure(:final requiredMb, :final availableMb) =>
          'Not enough storage — need ${_formatMb(requiredMb)}, only ${_formatMb(availableMb)} free',
        CancelledFailure() => 'Operation cancelled',
        UnknownFailure(:final message) => 'Something went wrong: $message',
      };

  static String _formatMb(int mb) {
    if (mb >= 1024) return '${(mb / 1024).toStringAsFixed(1)} GB';
    return '$mb MB';
  }
}
