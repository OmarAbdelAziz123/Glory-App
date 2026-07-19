import 'package:flutter/material.dart';

final class SplashLogo extends StatelessWidget {
  const SplashLogo({
    super.key,
    required this.scaleAnimation,
    required this.opacityAnimation,
  });

  final Animation<double> scaleAnimation;
  final Animation<double> opacityAnimation;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacityAnimation,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: const _LogoWithHalo(),
      ),
    );
  }
}

final class _LogoWithHalo extends StatelessWidget {
  const _LogoWithHalo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Subtle golden halo behind the logo
          Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color(0x30FEB825),
                  Color(0x10FEB825),
                  Colors.transparent,
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          Image.asset(
            'assets/images/pngs/splash_logo.png',
            width: 140,
            height: 140,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
