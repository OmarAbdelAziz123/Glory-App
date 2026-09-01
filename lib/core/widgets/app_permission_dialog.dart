import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../l10n/l10n_extension.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles_extension.dart';
import 'app_button.dart';

final class AppPermissionDialog extends StatelessWidget {
  const AppPermissionDialog({
    super.key,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimaryPressed,
    this.secondaryLabel,
    this.onSecondaryPressed,
    this.icon = Iconsax.camera,
  });

  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimaryPressed;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryPressed;
  final IconData icon;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    required String primaryLabel,
    required VoidCallback onPrimaryPressed,
    String? secondaryLabel,
    VoidCallback? onSecondaryPressed,
    IconData icon = Iconsax.camera,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: AppColors.neutral1000.withValues(alpha: 0.45),
      builder: (_) => AppPermissionDialog(
        title: title,
        message: message,
        primaryLabel: primaryLabel,
        onPrimaryPressed: onPrimaryPressed,
        secondaryLabel: secondaryLabel,
        onSecondaryPressed: onSecondaryPressed,
        icon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolvedSecondaryLabel = secondaryLabel ?? context.l10n.cancel;

    return Dialog(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary10,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.contentSemibold.copyWith(
                color: AppColors.neutral1000,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.captionRegular.copyWith(
                color: AppColors.neutral600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: primaryLabel,
              height: 52,
              onPressed: () {
                Navigator.of(context).pop(true);
                onPrimaryPressed();
              },
            ),
            const SizedBox(height: 12),
            AppButton(
              label: resolvedSecondaryLabel,
              height: 52,
              variant: AppButtonVariant.outlined,
              onPressed: () {
                Navigator.of(context).pop(false);
                onSecondaryPressed?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}
