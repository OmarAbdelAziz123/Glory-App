import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';

final class AppSocialButton extends StatelessWidget {
  const AppSocialButton({
    super.key,
    required this.iconAsset,
    required this.onPressed,
  });

  final String iconAsset;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: SvgPicture.asset(iconAsset, width: 24, height: 24),
      ),
    );
  }
}
