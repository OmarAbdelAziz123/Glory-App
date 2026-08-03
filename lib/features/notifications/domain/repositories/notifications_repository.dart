import '../../../../core/result/result.dart';
import '../entities/notification_entity.dart';

abstract interface class NotificationsRepository {
  Future<Result<NotificationsPageEntity>> getNotifications({
    int page = 1,
    int limit = 20,
    bool? unreadOnly,
  });

  Future<Result<int>> getUnreadCount();

  Future<Result<NotificationEntity>> getNotificationById(String id);

  Future<Result<int>> markAllAsRead();
}
