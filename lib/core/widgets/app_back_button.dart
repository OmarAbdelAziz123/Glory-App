import 'package:flutter/material.dart';
import 'package:glory_gym/core/constants/app_spacing.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';

final class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
    this.onTap,
    this.materialColor = AppColors.white,
    this.borderRadius,
    this.iconColor,
    this.hasBorder = true,
  });

  final VoidCallback? onTap;
  final Color materialColor;
  final double? borderRadius;
  final Color? iconColor;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    void handleBack() {
      if (onTap != null) {
        onTap!();
        return;
      }
      if (context.canPop()) {
        context.pop();
      }
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Material(
        color: materialColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? AppSpacing.xs),
          side: hasBorder
              ? const BorderSide(color: AppColors.neutral200, width: 0.5)
              : BorderSide.none,
        ),
        child: Center(
          child: BackButton(
            onPressed: handleBack,
            style: IconButton.styleFrom(
              iconSize: 18,
              foregroundColor: iconColor ?? AppColors.neutral1000,
            ),
          ),
        ),
      ),
    );
  }
}
