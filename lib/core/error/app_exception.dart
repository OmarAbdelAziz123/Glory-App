sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class ServerException extends AppException {
  const ServerException([super.message = 'Server error occurred']);
}

final class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection']);
}

final class CacheException extends AppException {
  const CacheException([super.message = 'Cache error occurred']);
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized access']);
}

final class ValidationException extends AppException {
  const ValidationException([super.message = 'Validation failed']);
}
