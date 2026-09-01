import 'dart:developer' as developer;
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../firebase_options.dart';
import '../di/service_locator.dart';
import '../l10n/fallback_messages.dart';
import 'notification_service.dart';

/// Background FCM handler — must be a top-level function registered in [main].
@pragma('vm:entry-point')
Future<void> fcmBackgroundHandler(RemoteMessage message) async {
  if (kIsWeb) return;

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _FcmNotificationPresenter.ensureReady();
  await _FcmNotificationPresenter.show(message);
}

/// Firebase Cloud Messaging setup, permissions, and message display.
abstract final class FcmService {
  static const _iosTokenRetryDelays = [
    Duration(seconds: 2),
    Duration(seconds: 5),
    Duration(seconds: 10),
  ];

  static var _iosTokenRetryAttempt = 0;
  static Future<void> initialize() async {
    if (kIsWeb) return;

    await _requestPermissions();
    await _configurePlatformPresentation();
    await _logCurrentToken();

    FirebaseMessaging.instance.onTokenRefresh.listen(_logTokenSecurely);
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpened);
    await _handleInitialMessage();
  }

  static Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        await Permission.notification.request();
      }
    }

    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (!kDebugMode) return;

    developer.log(
      'Authorization: ${settings.authorizationStatus}',
      name: 'FCM',
    );
  }

  static Future<void> _configurePlatformPresentation() async {
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  static Future<void> _onForegroundMessage(RemoteMessage message) async {
    _logDebug('Foreground message: ${message.messageId}');
    await _FcmNotificationPresenter.show(message);
  }

  static void _onMessageOpened(RemoteMessage message) {
    _logDebug('Notification opened: ${message.messageId}');
    // Navigation can be wired here when deep-link payloads are defined.
  }

  static Future<void> _handleInitialMessage() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      _onMessageOpened(message);
    }
  }

  static Future<void> _logCurrentToken() async {
    try {
      if (!kIsWeb && Platform.isIOS) {
        final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken == null || apnsToken.isEmpty) {
          _scheduleIosTokenRetry();
          return;
        }
      }

      final token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) {
        if (!kIsWeb && Platform.isIOS) {
          _scheduleIosTokenRetry();
        } else {
          _logDebug(
            'FCM token unavailable yet. '
            'On iOS, ensure APNS is configured and retry after a moment.',
          );
        }
        return;
      }

      _iosTokenRetryAttempt = 0;
      _logTokenSecurely(token);
    } on FirebaseException catch (error, stackTrace) {
      if (error.code == 'apns-token-not-set') {
        _scheduleIosTokenRetry();
        return;
      }
      _logDebug(
        'Failed to retrieve FCM token: $error',
        error: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      _logDebug(
        'Failed to retrieve FCM token: $error',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static void _scheduleIosTokenRetry() {
    if (kIsWeb || !Platform.isIOS) return;
    if (_iosTokenRetryAttempt >= _iosTokenRetryDelays.length) {
      _logDebug(
        'APNS token still unavailable. '
        'Ensure Push Notifications capability and APNs key are configured in Firebase.',
      );
      return;
    }

    final delay = _iosTokenRetryDelays[_iosTokenRetryAttempt];
    _iosTokenRetryAttempt++;

    Future<void>.delayed(delay, () async {
      if (kIsWeb || !Platform.isIOS) return;
      await _logCurrentToken();
    });
  }

  static void _logTokenSecurely(String token) {
    if (!kDebugMode) return;

    developer.log(token, name: 'FCM_TOKEN');

    debugPrint('');
    debugPrint('══════════════════════════════════════════════');
    debugPrint('FCM TOKEN (debug only — omitted in release builds)');
    debugPrint(token);
    debugPrint('══════════════════════════════════════════════');
    debugPrint('');
  }

  static void _logDebug(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;
    developer.log(
      message,
      name: 'FCM',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

abstract final class _FcmNotificationPresenter {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _ready = false;

  static Future<void> ensureReady() async {
    if (_ready) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(
      AndroidNotificationChannel(
        NotificationService.channelId,
        FallbackMessages.appName,
        description: FallbackMessages.notificationsChannelDescription,
        importance: Importance.high,
      ),
    );

    _ready = true;
  }

  static Future<void> show(RemoteMessage message) async {
    final (title, body) = _titleAndBody(message);
    if (title == null && body == null) return;

    await ensureReady();

    if (!kIsWeb && sl.isRegistered<INotificationService>()) {
      await sl<INotificationService>().show(
        id: _notificationId(message),
        title: title ?? FallbackMessages.appName,
        body: body ?? '',
        payload: message.data.isEmpty ? null : message.data.toString(),
      );
      return;
    }

    await _plugin.show(
      id: _notificationId(message),
      title: title ?? FallbackMessages.appName,
      body: body ?? '',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationService.channelId,
          FallbackMessages.appName,
          channelDescription: FallbackMessages.notificationsChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data.isEmpty ? null : message.data.toString(),
    );
  }

  static (String?, String?) _titleAndBody(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      return (notification.title, notification.body);
    }

    final data = message.data;
    final title = _firstNonEmpty([
      data['title'],
      data['titleAr'],
      data['titleEn'],
    ]);
    final body = _firstNonEmpty([
      data['body'],
      data['bodyAr'],
      data['bodyEn'],
    ]);

    return (title, body);
  }

  static String? _firstNonEmpty(List<Object?> values) {
    for (final value in values) {
      final text = value?.toString().trim();
      if (text != null && text.isNotEmpty) return text;
    }
    return null;
  }

  static int _notificationId(RemoteMessage message) {
    final id = message.messageId;
    if (id != null && id.isNotEmpty) return id.hashCode;
    return message.hashCode;
  }
}
