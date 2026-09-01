import 'package:dio/dio.dart';
import '../../../../core/l10n/fallback_messages.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/result/result.dart';
import '../models/notification_model.dart';
import '../models/notifications_api_responses.dart';
import 'notifications_api.dart';

final class NotificationsRemoteApiService extends ApiService {
  NotificationsRemoteApiService(super.dio, this._notificationsApi);

  final NotificationsApi _notificationsApi;

  Future<Result<NotificationsApiResponse>> getNotifications({
    int page = 1,
    int limit = 20,
    bool? unreadOnly,
  }) =>
      _guard(() async {
        final response = await _notificationsApi.getNotifications(
          page: page,
          limit: limit,
          unreadOnly: unreadOnly,
        );
        if (!response.success) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return Success(response);
      });

  Future<Result<int>> getUnreadCount() => _guard(() async {
        final response = await _notificationsApi.getUnreadCount();
        if (!response.success || response.data == null) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return Success(response.data!.count);
      });

  Future<Result<NotificationModel>> getNotificationById(String id) =>
      _guard(() async {
        final response = await _notificationsApi.getNotificationById(id);
        if (!response.success || response.data == null) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return Success(response.data!);
      });

  Future<Result<int>> markAllAsRead() => _guard(() async {
        final response = await _notificationsApi.markAllAsRead();
        if (!response.success || response.data == null) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return Success(response.data!.updated);
      });

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
