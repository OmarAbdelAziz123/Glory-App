import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;

import '../network/api_client.dart';
import '../network/network_info.dart';
import '../notifications/notification_service.dart';
import '../storage/local_storage.dart';
import '../storage/secure_storage.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  await _registerCore();
}

Future<void> _registerCore() async {
  tz.initializeTimeZones();

  // ── External ──────────────────────────────────────────
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  sl.registerLazySingleton<FlutterLocalNotificationsPlugin>(
    () => FlutterLocalNotificationsPlugin(),
  );

  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // ── Storage ───────────────────────────────────────────
  sl.registerLazySingleton<ILocalStorage>(() => LocalStorage(sl()));
  sl.registerLazySingleton<ISecureStorage>(() => SecureStorage(sl()));

  // ── Network ───────────────────────────────────────────
  sl.registerLazySingleton<Dio>(
    () => ApiClient.create(secureStorage: sl(), localStorage: sl()),
  );
  sl.registerLazySingleton<INetworkInfo>(() => NetworkInfo(sl()));

  // ── Notifications ─────────────────────────────────────
  sl.registerLazySingleton<INotificationService>(
    () => NotificationService(sl()),
  );
  await sl<INotificationService>().initialize();
}
