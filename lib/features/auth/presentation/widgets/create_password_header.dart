import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';

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
          context.l10n.addStrongPasswordHint,
          style: context.captionRegular.copyWith(color: AppColors.neutral500),
        ),
      ],
    );
  }
}
