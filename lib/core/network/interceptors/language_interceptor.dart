import 'package:dio/dio.dart';

import '../../storage/local_storage.dart';
import '../../storage/storage_keys.dart';

final class LanguageInterceptor extends Interceptor {
  LanguageInterceptor(this._localStorage);

  final ILocalStorage _localStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final language = await _localStorage.getString(StorageKeys.language) ?? 'ar';
    options.headers['Accept-Language'] = language;
    handler.next(options);
  }
}
