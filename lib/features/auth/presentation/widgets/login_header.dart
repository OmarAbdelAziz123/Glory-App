import 'package:flutter/material.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles_extension.dart';

final class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('اهلا بعودتك', style: context.heading1),
        8.vertical,
        Text(
          'الرجاء إدخال بريدك الإلكتروني او رقم هاتفك ومع كلمة المرور للوصول إلى حسابك.',
          style: context.captionRegular.copyWith(color: AppColors.neutral500),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
