/// Custom exceptions for the app.
library;

class ServerException implements Exception {
  const ServerException({required this.statusCode, required this.message});
  final int statusCode;
  final String message;
}

class NetworkException implements Exception {
  const NetworkException({required this.message});
  final String message;
}

class StorageException implements Exception {
  const StorageException({required this.message});
  final String message;
}

class ExtractionException implements Exception {
  const ExtractionException({required this.message});
  final String message;
}

class InstallationException implements Exception {
  const InstallationException({required this.message});
  final String message;
}
