import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../../core/theme/app_colors.dart';

final class SplashLoader extends StatelessWidget {
  const SplashLoader({super.key, required this.opacityAnimation});

  final Animation<double> opacityAnimation;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacityAnimation,
      child: const _PulsingDots(),
    );
  }
}

final class _PulsingDots extends StatelessWidget {
  const _PulsingDots();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 16,
      child: LoadingIndicator(
        indicatorType: Indicator.ballPulse,
        colors: const [
          AppColors.primary,
          AppColors.primary300,
          AppColors.primary200,
        ],
        strokeWidth: 1,
      ),
    );
  }
}
