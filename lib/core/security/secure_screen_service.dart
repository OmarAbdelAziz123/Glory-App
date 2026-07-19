import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:screen_protector/screen_protector.dart';

/// Enables platform screenshot / screen-recording protection.
final class SecureScreenService {
  SecureScreenService._();

  static const _channel = MethodChannel('com.app.glory_gym/secure_screen');

  static int _activeScopes = 0;

  static Future<void> enable() async {
    _activeScopes++;
    if (_activeScopes == 1) {
      if (kIsWeb) return;
      if (Platform.isAndroid) {
        await _channel.invokeMethod<void>('enable');
      } else if (Platform.isIOS) {
        await ScreenProtector.protectDataLeakageOn();
      }
    }
  }

  static Future<void> disable() async {
    if (_activeScopes == 0) return;
    _activeScopes--;
    if (_activeScopes == 0) {
      if (kIsWeb) return;
      if (Platform.isAndroid) {
        await _channel.invokeMethod<void>('disable');
      } else if (Platform.isIOS) {
        await ScreenProtector.protectDataLeakageOff();
      }
    }
  }
}
