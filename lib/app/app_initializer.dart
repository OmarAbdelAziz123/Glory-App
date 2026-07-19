import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../core/di/service_locator.dart';

final class AppInitializer {
  AppInitializer._();

  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
    await _initHydratedStorage();
    await setupServiceLocator();
    // Uncomment after running: flutterfire configure
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
