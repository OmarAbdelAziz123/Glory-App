import 'package:dio/dio.dart';

import '../../error/app_exception.dart';

final class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err.copyWith(error: _mapToAppException(err)));
  }

  AppException _mapToAppException(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.connectionError =>
        const NetworkException(),
      DioExceptionType.badResponse => _mapStatusCode(e.response?.statusCode),
      DioExceptionType.cancel => const ServerException('Request cancelled'),
      _ => ServerException(e.message ?? 'Unexpected error'),
    };
  }

  AppException _mapStatusCode(int? statusCode) => switch (statusCode) {
        401 => const UnauthorizedException(),
        int s when s >= 500 => const ServerException('Server error'),
        int s when s >= 400 => const ServerException('Client error'),
        _ => const ServerException(),
      };
}
