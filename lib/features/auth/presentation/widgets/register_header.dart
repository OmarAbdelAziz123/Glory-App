import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';

final class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.l10n.welcomeToGloryGym, style: context.heading1),
        const SizedBox(height: 8),
        Text(
          context.l10n.forgotPasswordEmailHint,
          style: context.captionRegular.copyWith(color: AppColors.neutral500),
        ),
      ],
    );
  }
}
