import '../l10n/fallback_messages.dart';

sealed class AppFailure {
  AppFailure(this.message);

  final String message;
}

final class ServerFailure extends AppFailure {
  ServerFailure([String? message])
      : super(message ?? FallbackMessages.errorServer);
}

final class NetworkFailure extends AppFailure {
  NetworkFailure([String? message])
      : super(message ?? FallbackMessages.noInternet);
}

final class CacheFailure extends AppFailure {
  CacheFailure([String? message])
      : super(message ?? FallbackMessages.cacheError);
}

final class UnauthorizedFailure extends AppFailure {
  UnauthorizedFailure([String? message])
      : super(message ?? FallbackMessages.errorUnauthorized);
}

final class ValidationFailure extends AppFailure {
  ValidationFailure([String? message])
      : super(message ?? FallbackMessages.validationFailed);
}
