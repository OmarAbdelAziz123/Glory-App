import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

final class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (actionLabel != null && onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: Styles.captionRegular(context).copyWith(
                color: AppColors.primary,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primary,
              ),
            ),
          )
        else
          const SizedBox.shrink(),
        Text(title, style: Styles.highlightBold(context)),
      ],
    );
  }
}
