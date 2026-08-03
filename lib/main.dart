import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/app_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initialize();
  runApp(const App());
}
// 668914

/// Remove change username & Photo in Profile Screen only one time from Admin Dashboard
/// and Password
/// 