import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';

/// Detects Android 3-button navigation and exposes a global bottom inset fix.
abstract final class NavigationModeService {
  NavigationModeService._();

  static const _channel = MethodChannel('com.app.glorygym/navigation_mode');
  static const double threeButtonNavBottomPadding = 36;

  static bool _is3ButtonNavigation = false;

  static bool get is3ButtonNavigation => _is3ButtonNavigation;

  static double get extraBottomPadding =>
      _is3ButtonNavigation ? threeButtonNavBottomPadding : 0;

  static Future<void> check3ButtonNavigation() async {
    if (kIsWeb || !Platform.isAndroid) return;

    try {
      final is3Button = await _channel.invokeMethod<bool>('is3ButtonNav');
      _is3ButtonNavigation = is3Button ?? false;
    } on PlatformException {
      _is3ButtonNavigation = false;
    } on MissingPluginException {
      _is3ButtonNavigation = false;
    }
  }
}
