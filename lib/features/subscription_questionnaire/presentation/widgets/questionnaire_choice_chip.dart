import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';

final class QuestionnaireChoiceChip extends StatelessWidget {
  const QuestionnaireChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.expanded = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final child = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: selected
                ? null
                : Border.all(color: AppColors.neutral400),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.contentRegular.copyWith(
                color: selected ? AppColors.neutral100 : AppColors.neutral400,
              ),
            ),
          ),
        ),
      ),
    );

    if (expanded) return Expanded(child: child);
    return child;
  }
}
