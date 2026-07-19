import 'package:dio/dio.dart';

import '../storage/local_storage.dart';
import '../storage/secure_storage.dart';
import 'endpoints.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/language_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

final class ApiClient {
  ApiClient._();

  static Dio create({
    required ISecureStorage secureStorage,
    required ILocalStorage localStorage,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: Endpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(secureStorage),
      LanguageInterceptor(localStorage),
      ErrorInterceptor(),
      LoggingInterceptor(),
    ]);

    return dio;
  }
}
