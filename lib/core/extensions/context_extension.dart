import 'package:flutter/material.dart';

extension ContextX on BuildContext {
  // ── MediaQuery ────────────────────────────────────────
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => mediaQuery.size.width;
  double get screenHeight => mediaQuery.size.height;
  double get topPadding => mediaQuery.padding.top;
  double get bottomPadding => mediaQuery.padding.bottom;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  bool get isKeyboardOpen => mediaQuery.viewInsets.bottom > 0;
  bool get isDarkMode => mediaQuery.platformBrightness == Brightness.dark;

  // ── Theme ─────────────────────────────────────────────
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // ── Navigation ────────────────────────────────────────
  /// Imperative [Navigator] (Navigator 1.0). Prefer [GoRouter] (`context.go` / `context.push`) for app routes.
  NavigatorState get navigator => Navigator.of(this);

  Future<T?> pushWidget<T>(Widget page) => navigator.push<T>(
        MaterialPageRoute<T>(builder: (_) => page),
      );
}
