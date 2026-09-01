import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/l10n/l10n_extension.dart';
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
        child: Column(
          children: [
            const _AppTitle(),
            const SizedBox(height: 10),
            const _GoldDivider(),
            const SizedBox(height: 16),
            _Tagline(text: context.l10n.splashTagline),
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
  const _Tagline({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: AppColors.neutral400,
        letterSpacing: 3,
      ),
    );
  }
}
