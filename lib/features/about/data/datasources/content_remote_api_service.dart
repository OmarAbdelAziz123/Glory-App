import 'package:dio/dio.dart';
import '../../../../core/l10n/fallback_messages.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/result/result.dart';
import '../models/contact_links_model.dart';
import '../models/faq_model.dart';
import '../models/feedback_request.dart';
import '../models/info_page_model.dart';
import 'content_api.dart';

final class ContentRemoteApiService extends ApiService {
  ContentRemoteApiService(super.dio, this._contentApi);

  final ContentApi _contentApi;

  Future<Result<List<InfoPageModel>>> getInfoPages() => _guard(
        () async {
          final response = await _contentApi.getInfoPages();
          return _mapList(response.success, response.data, response.message);
        },
      );

  Future<Result<InfoPageModel>> getInfoPageByKey(String key) => _guard(
        () async {
          final response = await _contentApi.getInfoPageByKey(key);
          return _mapSingle(response.success, response.data, response.message);
        },
      );

  Future<Result<List<FaqModel>>> getFaqs() => _guard(
        () async {
          final response = await _contentApi.getFaqs();
          return _mapList(response.success, response.data, response.message);
        },
      );

  Future<Result<ContactLinksModel>> getContactLinks() => _guard(
        () async {
          final response = await _contentApi.getContactLinks();
          return _mapSingle(response.success, response.data, response.message);
        },
      );

  Future<Result<void>> submitFeedback(FeedbackRequest request) => _guard(
        () async {
          final response = await _contentApi.submitFeedback(request);
          if (!response.success) {
            return Failure(
              ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
            );
          }
          return const Success(null);
        },
      );

  Result<List<T>> _mapList<T>(
    bool success,
    List<T>? data,
    String? message,
  ) {
    if (!success || data == null) {
      return Failure(ServerFailure(message ?? FallbackMessages.errorTryAgain));
    }
    return Success(data);
  }

  Result<T> _mapSingle<T>(bool success, T? data, String? message) {
    if (!success || data == null) {
      return Failure(ServerFailure(message ?? FallbackMessages.errorTryAgain));
    }
    return Success(data);
  }

  Future<Result<R>> _guard<R>(Future<Result<R>> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      final inner = e.error;
      if (inner is AppException) {
        return Failure(_mapException(inner));
      }
      return Failure(
        switch (e.type) {
          DioExceptionType.connectionTimeout ||
          DioExceptionType.receiveTimeout ||
          DioExceptionType.sendTimeout ||
          DioExceptionType.connectionError =>
            NetworkFailure(FallbackMessages.noInternet),
          _ => ServerFailure(e.message ?? FallbackMessages.errorGeneral),
        },
      );
    } on AppException catch (e) {
      return Failure(_mapException(e));
    } catch (e) {
      return Failure(ServerFailure(e.toString()));
    }
  }

  AppFailure _mapException(AppException e) => switch (e) {
        NetworkException() => NetworkFailure(e.message),
        UnauthorizedException() => UnauthorizedFailure(e.message),
        ServerException() => ServerFailure(e.message),
        CacheException() => CacheFailure(e.message),
        ValidationException() => ValidationFailure(e.message),
      };
}
