import 'package:flutter/material.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';

final class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(context.l10n.welcomeBackAlt, style: context.heading1),
        8.vertical,
        Text(
          context.l10n.loginEmailOrPhoneHint,
          style: context.captionRegular.copyWith(color: AppColors.neutral500),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
