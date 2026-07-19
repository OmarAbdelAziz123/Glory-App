sealed class AppFailure {
  const AppFailure(this.message);

  final String message;
}

final class ServerFailure extends AppFailure {
  const ServerFailure([super.message = 'Server failure']);
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = 'Network failure']);
}

final class CacheFailure extends AppFailure {
  const CacheFailure([super.message = 'Cache failure']);
}

final class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure([super.message = 'Unauthorized']);
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure([super.message = 'Validation failed']);
}
