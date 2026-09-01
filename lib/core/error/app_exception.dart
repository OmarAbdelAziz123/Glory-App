import '../l10n/fallback_messages.dart';

sealed class AppException implements Exception {
  AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class ServerException extends AppException {
  ServerException([String? message])
      : super(message ?? FallbackMessages.errorServer);
}

final class NetworkException extends AppException {
  NetworkException([String? message])
      : super(message ?? FallbackMessages.noInternet);
}

final class CacheException extends AppException {
  CacheException([String? message])
      : super(message ?? FallbackMessages.cacheError);
}

final class UnauthorizedException extends AppException {
  UnauthorizedException([String? message])
      : super(message ?? FallbackMessages.errorUnauthorized);
}

final class ValidationException extends AppException {
  ValidationException([String? message])
      : super(message ?? FallbackMessages.validationFailed);
}
