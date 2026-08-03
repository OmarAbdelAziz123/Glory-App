import 'package:dio/dio.dart';

import '../../network/endpoints.dart';
import '../../storage/secure_storage.dart';
import '../../storage/storage_keys.dart';

final class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._secureStorage);

  final ISecureStorage _secureStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.read(StorageKeys.accessToken);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final refreshed = await _tryRefreshToken(err.requestOptions);
      if (refreshed != null) {
        handler.resolve(refreshed);
        return;
      }
    }
    handler.next(err);
  }

  Future<Response<dynamic>?> _tryRefreshToken(RequestOptions original) async {
    final refreshToken = await _secureStorage.read(StorageKeys.refreshToken);
    if (refreshToken == null || refreshToken.isEmpty) return null;

    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: Endpoints.baseUrl,
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final response = await dio.post<Map<String, dynamic>>(
        Endpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      final body = response.data;
      if (body == null || body['success'] != true) return null;

      final data = body['data'] as Map<String, dynamic>?;
      final newAccessToken = data?['accessToken'] as String?;
      final newRefreshToken = data?['refreshToken'] as String?;

      if (newAccessToken == null || newAccessToken.isEmpty) return null;

      await _secureStorage.write(StorageKeys.accessToken, newAccessToken);
      if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
        await _secureStorage.write(StorageKeys.refreshToken, newRefreshToken);
      }

      original.headers['Authorization'] = 'Bearer $newAccessToken';
      return dio.fetch<dynamic>(original);
    } catch (_) {
      await _secureStorage.delete(StorageKeys.accessToken);
      await _secureStorage.delete(StorageKeys.refreshToken);
      await _secureStorage.delete(StorageKeys.userId);
      return null;
    }
  }
}
