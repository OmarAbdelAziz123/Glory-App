import 'package:flutter/material.dart';

import '../../../../core/extensions/num_spacing_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';

final class QuestionnaireStepTitle extends StatelessWidget {
  const QuestionnaireStepTitle({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: context.featureBold.copyWith(color: AppColors.neutral1000),
        ),
        6.vertical,
        Text(
          subtitle,
          style: context.captionRegular.copyWith(color: AppColors.neutral400),
        ),
      ],
    );
  }
}
