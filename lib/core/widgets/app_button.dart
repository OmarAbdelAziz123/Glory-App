import 'package:flutter/material.dart';
import 'package:glory_gym/core/constants/app_spacing.dart';

import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

enum AppButtonVariant { primary, outlined }

final class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.variant = AppButtonVariant.primary,
    this.height = 56.0,
    this.width = double.infinity,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonVariant variant;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: switch (variant) {
        AppButtonVariant.primary => _PrimaryButton(
          label: label,
          onPressed: isLoading ? null : onPressed,
          isLoading: isLoading,
        ),
        AppButtonVariant.outlined => _OutlinedBtn(
          label: label,
          onPressed: isLoading ? null : onPressed,
          isLoading: isLoading,
        ),
      },
    );
  }
}

final class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    required this.isLoading,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final bool disabled = onPressed == null && !isLoading;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: disabled ? AppColors.neutral400 : AppColors.primary,
        disabledBackgroundColor: AppColors.neutral300,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Color(0xFFD9D9D9),
              ),
            )
          : Text(
              label,
              style: Styles.contentSemibold(
                context,
              ).copyWith(color: AppColors.neutral100),
            ),
    );
  }
}

final class _OutlinedBtn extends StatelessWidget {
  const _OutlinedBtn({
    required this.label,
    required this.onPressed,
    required this.isLoading,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary,
              ),
            )
          : Text(
              label,
              style: Styles.contentSemibold(
                context,
              ).copyWith(color: AppColors.primary),
            ),
    );
  }
}
