import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../widgets/splash_brand_name.dart';
import '../widgets/splash_loader.dart';
import '../widgets/splash_logo.dart';

final class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

final class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<Offset> _brandSlide;
  late final Animation<double> _brandOpacity;
  late final Animation<double> _loaderOpacity;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _controller
        .forward()
        .then((_) => _navigateAfterDelay());
  }

  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.elasticOut),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.25),
      ),
    );

    _brandSlide =
        Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.75, curve: Curves.easeOut),
      ),
    );

    _brandOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.65),
      ),
    );

    _loaderOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.70, 1.0),
      ),
    );
  }

  Future<void> _navigateAfterDelay() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (mounted) context.go(AppRoutes.login);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SplashLogo(
                    scaleAnimation: _logoScale,
                    opacityAnimation: _logoOpacity,
                  ),
                  const SizedBox(height: 36),
                  SplashBrandName(
                    slideAnimation: _brandSlide,
                    opacityAnimation: _brandOpacity,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: Center(
                child: SplashLoader(opacityAnimation: _loaderOpacity),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
