import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_styles_extension.dart';

final class AppNavTile extends StatelessWidget {
  const AppNavTile({
    super.key,
    required this.iconAsset,
    required this.label,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
  });

  final String iconAsset;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.red : AppColors.neutral900;
    final iconColor = isDestructive ? AppColors.red : AppColors.neutral700;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/images/svgs/$iconAsset',
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: context.highlightStandard.copyWith(color: color),
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 12), trailing!],
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDestructive ? AppColors.red : AppColors.neutral1000,
            ),
          ],
        ),
      ),
    );
  }
}
