import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';

final class QuestionnaireRequiredLabel extends StatelessWidget {
  const QuestionnaireRequiredLabel({
    super.key,
    required this.label,
    this.required = true,
    this.trailing,
  });

  final String label;
  final bool required;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              style: context.highlightEmphasis.copyWith(
                color: AppColors.neutral1000,
              ),
              children: [
                TextSpan(text: label),
                if (required)
                  TextSpan(
                    text: ' *',
                    style: context.highlightEmphasis.copyWith(
                      color: AppColors.red100,
                    ),
                  ),
              ],
            ),
            textAlign: TextAlign.start,
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 8),
          trailing!,
        ],
      ],
    );
  }
}
