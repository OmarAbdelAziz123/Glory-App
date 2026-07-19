import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles_extension.dart';

final class ForgotPasswordHeader extends StatelessWidget {
  const ForgotPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('نسيت كلمة المرور', style: context.heading1),
        const SizedBox(height: 8),
        Text(
          'الرجاء إدخال بريدك الإلكتروني او رقم هاتفك لإرسال رمز التأكيد إليه',
          style: context.captionRegular.copyWith(color: AppColors.neutral500),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
