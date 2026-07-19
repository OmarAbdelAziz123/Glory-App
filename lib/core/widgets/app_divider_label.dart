import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_styles_extension.dart';

final class AppDividerLabel extends StatelessWidget {
  const AppDividerLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: AppColors.neutral200, thickness: 0.5),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: context.captionRegular.copyWith(color: AppColors.neutral400),
          ),
        ),
        const Expanded(
          child: Divider(color: AppColors.neutral200, thickness: 0.5),
        ),
      ],
    );
  }
}
