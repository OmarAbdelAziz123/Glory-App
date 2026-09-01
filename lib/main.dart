import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/app_initializer.dart';
import 'core/notifications/fcm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);
  await AppInitializer.initialize();
  runApp(const App());
}
// 668914

/// Remove change username & Photo in Profile Screen only one time from Admin Dashboard
/// and Password
/// 
/// شات بين المستخدمين والسيلز في التطبيق
/// 