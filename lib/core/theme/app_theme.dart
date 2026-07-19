import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.primary10;
          }
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return AppColors.primary10;
          }
          return null;
        }),
      ),
    ),
  );
}
