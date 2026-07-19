import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

final class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
      ),
      child: child,
    );
  }
}
