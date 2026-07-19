import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_colors.dart';

final class SplashBrandName extends StatelessWidget {
  const SplashBrandName({
    super.key,
    required this.slideAnimation,
    required this.opacityAnimation,
  });

  final Animation<Offset> slideAnimation;
  final Animation<double> opacityAnimation;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacityAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: const Column(
          children: [
            _AppTitle(),
            SizedBox(height: 10),
            _GoldDivider(),
            SizedBox(height: 16),
            _Tagline(),
          ],
        ),
      ),
    );
  }
}

final class _AppTitle extends StatelessWidget {
  const _AppTitle();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'GLORY ',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.neutral900,
              letterSpacing: 4,
            ),
          ),
          TextSpan(
            text: 'GYM',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              letterSpacing: 4,
            ),
          ),
        ],
      ),
    );
  }
}

final class _GoldDivider extends StatelessWidget {
  const _GoldDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 1,
          color: AppColors.primary.withValues(alpha: 0.4),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
          ),
        ),
        Container(
          width: 40,
          height: 1,
          color: AppColors.primary.withValues(alpha: 0.4),
        ),
      ],
    );
  }
}

final class _Tagline extends StatelessWidget {
  const _Tagline();

  @override
  Widget build(BuildContext context) {
    return Text(
      'TRAIN  ·  GROW  ·  DOMINATE',
      style: GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: AppColors.neutral400,
        letterSpacing: 3,
      ),
    );
  }
}
