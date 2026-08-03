import 'package:flutter_test/flutter_test.dart';
import 'package:glory_gym/core/result/result.dart';
import 'package:glory_gym/core/utils/notification_utils.dart';
import 'package:glory_gym/features/notifications/data/mappers/notification_mappers.dart';
import 'package:glory_gym/features/notifications/data/models/notification_model.dart';
import 'package:glory_gym/features/notifications/domain/entities/notification_entity.dart';
import 'package:glory_gym/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:glory_gym/features/notifications/presentation/cubits/notifications_list/notifications_list_cubit.dart';
import 'package:glory_gym/features/notifications/presentation/cubits/notifications_unread/notifications_unread_cubit.dart';

import '../../helpers/fixtures.dart';

final class _FakeNotificationsRepository implements NotificationsRepository {
  _FakeNotificationsRepository({
    this.notifications = const [],
    this.unreadCount = 0,
  });

  final List<NotificationEntity> notifications;
  final int unreadCount;

  @override
  Future<Result<NotificationsPageEntity>> getNotifications({
    int page = 1,
    int limit = 20,
    bool? unreadOnly,
  }) async {
    return Success(
      NotificationsPageEntity(
        items: notifications,
        page: 1,
        totalPages: 1,
      ),
    );
  }

  @override
  Future<Result<int>> getUnreadCount() async => Success(unreadCount);

  @override
  Future<Result<NotificationEntity>> getNotificationById(String id) async {
    final notification = notifications.firstWhere((n) => n.id == id);
    return Success(notification.copyWith(isRead: true));
  }

  @override
  Future<Result<int>> markAllAsRead() async => const Success(0);
}

void main() {
  group('Notification models', () {
    test('parses notification item', () {
      final model = NotificationModel.fromJson(notificationJson);
      final entity = model.toEntity();

      expect(model.titleAr, 'اوفر شهر 4');
      expect(entity.isRead, isFalse);
      expect(entity.type, 'PUSH');
    });
  });

  group('NotificationUtils', () {
    test('picks localized title/body', () {
      final entity = NotificationModel.fromJson(notificationJson).toEntity();

      expect(
        NotificationUtils.title(entity, locale: 'ar'),
        'اوفر شهر 4',
      );
      expect(
        NotificationUtils.title(entity, locale: 'en'),
        'Get 4 months free',
      );
    });

    test('groups notifications by today label', () {
      final entity = NotificationEntity(
        id: '1',
        titleAr: 'test',
        titleEn: 'test',
        bodyAr: 'body',
        bodyEn: 'body',
        createdAt: DateTime.now(),
      );

      final groups = NotificationUtils.groupByDate([entity]);

      expect(groups, hasLength(1));
      expect(groups.first.label, 'اليوم');
    });
  });

  group('Notifications cubits', () {
    test('NotificationsListCubit loads notifications', () async {
      final entity = NotificationModel.fromJson(notificationJson).toEntity();
      final cubit = NotificationsListCubit(
        _FakeNotificationsRepository(notifications: [entity]),
      );

      await cubit.loadNotifications();

      expect(cubit.state.notifications, hasLength(1));
      expect(cubit.state.notifications.first.id, 'notif-1');

      await cubit.close();
    });

    test('openNotification marks item as read locally', () async {
      final entity = NotificationModel.fromJson(notificationJson).toEntity();
      final cubit = NotificationsListCubit(
        _FakeNotificationsRepository(notifications: [entity]),
      );

      await cubit.loadNotifications();
      final opened = await cubit.openNotification('notif-1');

      expect(opened, isNotNull);
      expect(cubit.state.notifications.first.isRead, isTrue);

      await cubit.close();
    });

    test('NotificationsUnreadCubit fetches badge count', () async {
      final cubit = NotificationsUnreadCubit(
        _FakeNotificationsRepository(unreadCount: 3),
      );

      await cubit.fetchUnreadCount();

      expect(cubit.state.count, 3);

      await cubit.close();
    });
  });
}
