import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles_extension.dart';

final class OtpHeader extends StatelessWidget {
  const OtpHeader({
    super.key,
    required this.email,
    required this.onChangeEmail,
  });

  final String email;
  final VoidCallback onChangeEmail;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('رمز التحقق', style: context.heading1),
        const SizedBox(height: 8),
        RichText(
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          text: TextSpan(
            style: context.captionRegular.copyWith(color: AppColors.neutral500),
            children: [
              const TextSpan(
                text: 'تم إرسال رمز مكون من 6 أرقام على بريدك الإلكتروني ',
              ),
              TextSpan(
                text: '( $email )',
                style: context.captionRegular.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onChangeEmail,
          child: Text(
            'تغير البريد الالكتروني',
            style: context.subtitleMedium.copyWith(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
