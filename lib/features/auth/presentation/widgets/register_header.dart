import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles_extension.dart';

final class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('اهلا بك في جلوري جيم', style: context.heading1),
        const SizedBox(height: 8),
        Text(
          'الرجاء إدخال بريدك الإلكتروني وسنرسل رمز التأكيد إلى بريدك الإلكتروني',
          style: context.captionRegular.copyWith(color: AppColors.neutral500),
        ),
      ],
    );
  }
}
