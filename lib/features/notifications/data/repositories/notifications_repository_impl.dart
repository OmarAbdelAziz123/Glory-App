import '../../../../core/error/app_failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_api_service.dart';
import '../mappers/notification_mappers.dart';
import '../models/notifications_api_responses.dart';

final class NotificationsRepositoryImpl implements NotificationsRepository {
  const NotificationsRepositoryImpl(this._remote);

  final NotificationsRemoteApiService _remote;

  @override
  Future<Result<NotificationsPageEntity>> getNotifications({
    int page = 1,
    int limit = 20,
    bool? unreadOnly,
  }) async {
    final result = await _remote.getNotifications(
      page: page,
      limit: limit,
      unreadOnly: unreadOnly,
    );

    return switch (result) {
      Success(:final data) => _mapPage(data),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<int>> getUnreadCount() => _remote.getUnreadCount();

  @override
  Future<Result<NotificationEntity>> getNotificationById(String id) async {
    final result = await _remote.getNotificationById(id);
    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<int>> markAllAsRead() => _remote.markAllAsRead();

  Result<NotificationsPageEntity> _mapPage(NotificationsApiResponse data) {
    final pageEntity = data.toPageEntity();
    if (pageEntity == null) {
      return const Failure(ServerFailure('حدث خطأ، حاول مرة أخرى'));
    }
    return Success(pageEntity);
  }
}
