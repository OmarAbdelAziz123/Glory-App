import '../../../../core/result/result.dart';
import '../entities/notification_entity.dart';

abstract interface class NotificationsRepository {
  Future<Result<List<NotificationEntity>>> getNotifications();

  Future<Result<void>> markAsRead(String id);

  Future<Result<void>> markAllAsRead();

  Future<Result<void>> deleteNotification(String id);
}
