import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles_extension.dart';

final class CreatePasswordHeader extends StatelessWidget {
  const CreatePasswordHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: context.heading1),
        Text(
          'يرجي إضافة كلمة مرور قوية للحفاظ علي بياناتك',
          style: context.captionRegular.copyWith(color: AppColors.neutral500),
        ),
      ],
    );
  }
}
