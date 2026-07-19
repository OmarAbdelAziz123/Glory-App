import 'package:dio/dio.dart';

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
    if (token != null) {
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

  // Returns a resolved response if refresh succeeds, null otherwise.
  Future<Response<dynamic>?> _tryRefreshToken(RequestOptions original) async {
    final refreshToken = await _secureStorage.read(StorageKeys.refreshToken);
    if (refreshToken == null) return null;

    try {
      final dio = Dio();
      // TODO: replace with Endpoints.refreshToken when wiring features
      final response = await dio.post<dynamic>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final newToken = response.data['access_token'] as String?;
      if (newToken == null) return null;

      await _secureStorage.write(StorageKeys.accessToken, newToken);

      // Retry the original request with the new token.
      original.headers['Authorization'] = 'Bearer $newToken';
      return dio.fetch<dynamic>(original);
    } catch (_) {
      await _secureStorage.deleteAll();
      return null;
    }
  }
}
