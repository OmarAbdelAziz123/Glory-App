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
      DioExceptionType.badResponse =>
        _mapStatusCode(e.response?.statusCode, e.response),
      DioExceptionType.cancel => const ServerException('Request cancelled'),
      _ => ServerException(e.message ?? 'Unexpected error'),
    };
  }

  AppException _mapStatusCode(int? statusCode, Response<dynamic>? response) {
    final message = _extractMessage(response?.data);
    return switch (statusCode) {
      401 => UnauthorizedException(message ?? 'Unauthorized access'),
      int s when s >= 500 => ServerException(message ?? 'Server error'),
      int s when s >= 400 => ServerException(message ?? 'Client error'),
      _ => ServerException(message ?? 'Unexpected error'),
    };
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) return message;
    }
    return null;
  }
}
