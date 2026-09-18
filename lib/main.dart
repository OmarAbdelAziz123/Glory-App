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