import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../../firebase_options.dart';
import '../core/di/service_locator.dart';
import '../core/l10n/locale_service.dart';
import '../core/notifications/fcm_service.dart';
import '../core/platform/navigation_mode_service.dart';

final class AppInitializer {
  AppInitializer._();

  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
    await _initHydratedStorage();
    await setupServiceLocator();
    await LocaleService.bootstrap();
    await NavigationModeService.check3ButtonNavigation();
    await _initializeFirebase();
  }

  static Future<void> _initializeFirebase() async {
    if (kIsWeb) return;

    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    await FcmService.initialize();
  }

  static Future<void> _initHydratedStorage() async {
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorageDirectory.web
          : HydratedStorageDirectory(
              (await getApplicationDocumentsDirectory()).path,
            ),
    );
  }
}
