import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/audio/splash_sound_service.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/locale_service.dart';
import '../../../../core/utils/onboarding_navigation.dart';
import '../../../auth/presentation/cubits/user_profile/user_profile_cubit.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../cubits/splash_cubit.dart';
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
  late final SplashSoundService _splashSound;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<Offset> _brandSlide;
  late final Animation<double> _brandOpacity;
  late final Animation<double> _loaderOpacity;

  @override
  void initState() {
    super.initState();
    _splashSound = SplashSoundService();
    _setupAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _splashSound.play();
      _runSplash();
    });
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

  Future<void> _runSplash() async {
    if (!mounted) return;

    final cubit = context.read<SplashCubit>();
    final profileCubit = context.read<UserProfileCubit>();

    await Future.wait([
      _controller.forward(),
      Future<void>.delayed(SplashSoundService.duration),
      cubit.checkSession(),
    ]);

    if (!mounted) return;

    if (cubit.state.isAuthenticated) {
      if (profileCubit.state.member == null) {
        await profileCubit.fetchProfile();
      }
      if (!mounted) return;
      await LocaleService.syncFromMember(profileCubit.state.member);
      if (!mounted) return;
      await navigateAfterAuthentication(
        context,
        onboardingCompleted: profileCubit.state.member?.onboardingCompleted,
      );
      return;
    }

    if (!mounted) return;
    context.go(AppRoutes.login);
  }

  @override
  void dispose() {
    _splashSound.dispose();
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

final class SplashScreenProvider extends StatelessWidget {
  const SplashScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SplashCubit>(),
      child: const SplashScreen(),
    );
  }
}
