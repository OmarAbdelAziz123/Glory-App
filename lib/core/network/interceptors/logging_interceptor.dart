import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

final class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      log(
        '[REQUEST] ${options.method} ${options.uri}\n'
        'Headers: ${options.headers}\n'
        'Data: ${options.data}',
        name: 'Network',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      log(
        '[RESPONSE] ${response.statusCode} ${response.requestOptions.uri}\n'
        'Data: ${response.data}',
        name: 'Network',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      log(
        '[ERROR] ${err.response?.statusCode} ${err.requestOptions.uri}\n'
        'Message: ${err.message}',
        name: 'Network',
        error: err,
      );
    }
    handler.next(err);
  }
}
