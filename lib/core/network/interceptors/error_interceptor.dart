import 'package:dio/dio.dart';

import '../../error/app_exception.dart';
import '../../l10n/fallback_messages.dart';

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
        NetworkException(FallbackMessages.noInternet),
      DioExceptionType.badResponse =>
        _mapStatusCode(e.response?.statusCode, e.response),
      DioExceptionType.cancel =>
        ServerException(FallbackMessages.requestCancelled),
      _ => ServerException(e.message ?? FallbackMessages.errorGeneral),
    };
  }

  AppException _mapStatusCode(int? statusCode, Response<dynamic>? response) {
    final message = _extractMessage(response?.data);
    return switch (statusCode) {
      401 => UnauthorizedException(
        message ?? FallbackMessages.errorUnauthorized,
      ),
      int s when s >= 500 =>
        ServerException(message ?? FallbackMessages.errorServer),
      int s when s >= 400 =>
        ServerException(message ?? FallbackMessages.clientError),
      _ => ServerException(message ?? FallbackMessages.errorGeneral),
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
