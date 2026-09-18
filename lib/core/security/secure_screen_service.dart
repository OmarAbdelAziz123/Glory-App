import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:screen_protector/screen_protector.dart';

/// Enables screenshot / screen-recording protection on iOS only.
final class SecureScreenService {
  SecureScreenService._();

  static int _activeScopes = 0;

  static Future<void> enable() async {
    _activeScopes++;
    if (_activeScopes == 1) {
      if (kIsWeb || !Platform.isIOS) return;
      await ScreenProtector.protectDataLeakageOn();
    }
  }

  static Future<void> disable() async {
    if (_activeScopes == 0) return;
    _activeScopes--;
    if (_activeScopes == 0) {
      if (kIsWeb || !Platform.isIOS) return;
      await ScreenProtector.protectDataLeakageOff();
    }
  }
}
