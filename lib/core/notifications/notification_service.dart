import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

abstract interface class INotificationService {
  Future<void> initialize();
  Future<bool> requestPermission();

  Future<void> show({
    required int id,
    required String title,
    required String body,
    String? payload,
  });

  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  });

  Future<void> cancel(int id);
  Future<void> cancelAll();
}

final class NotificationService implements INotificationService {
  NotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  static const _androidDetails = AndroidNotificationDetails(
    'glory_gym_channel',
    'Glory Gym',
    channelDescription: 'Glory Gym notifications',
    importance: Importance.high,
    priority: Priority.high,
  );

  static const _details = NotificationDetails(
    android: _androidDetails,
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  @override
  Future<void> initialize() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidInit, iOS: iosInit),
    );
  }

  @override
  Future<bool> requestPermission() async {
    final result = await _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    return result ?? true;
  }

  @override
  Future<void> show({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) =>
      _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: _details,
        payload: payload,
      );

  @override
  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) =>
      _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );

  @override
  Future<void> cancel(int id) => _plugin.cancel(id: id);

  @override
  Future<void> cancelAll() => _plugin.cancelAll();
}
