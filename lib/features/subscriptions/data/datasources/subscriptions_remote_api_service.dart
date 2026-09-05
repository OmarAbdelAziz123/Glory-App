import 'package:dio/dio.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../core/l10n/fallback_messages.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/result/result.dart';
import '../models/subscription_api_responses.dart';
import '../models/subscription_model.dart';
import 'subscriptions_api.dart';

final class SubscriptionsRemoteApiService extends ApiService {
  SubscriptionsRemoteApiService(super.dio, this._api);

  final SubscriptionsApi _api;

  Future<Result<SubscriptionsApiResponse>> getSubscriptions({
    int page = 1,
    int limit = 10,
  }) =>
      _guard(() async {
        final response = await _api.getSubscriptions(page: page, limit: limit);
        if (!response.success) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return Success(response);
      });

  Future<Result<SubscriptionModel>> getCurrentSubscription() =>
      _guard(() async {
        final response = await _api.getCurrentSubscription();
        return _mapSubscriptionResponse(response);
      });

  Result<SubscriptionModel> _mapSubscriptionResponse(
    SubscriptionApiResponse response,
  ) {
    if (!response.success || response.data == null) {
      return Failure(
        ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
      );
    }
    return Success(response.data!);
  }

  Future<Result<T>> _guard<T>(Future<Result<T>> Function() call) async {
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
