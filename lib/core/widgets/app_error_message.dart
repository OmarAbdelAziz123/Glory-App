import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_styles_extension.dart';

final class AppErrorMessage extends StatelessWidget {
  const AppErrorMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            message,
            style: context.captionRegular.copyWith(color: AppColors.red),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.cancel, color: AppColors.red, size: 22),
      ],
    );
  }
}
