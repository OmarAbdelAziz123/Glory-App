import 'package:flutter/material.dart';

import '../../../../core/extensions/num_spacing_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import 'questionnaire_required_label.dart';

final class QuestionnaireTextField extends StatelessWidget {
  const QuestionnaireTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.onChanged,
    this.required = true,
    this.keyboardType,
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool required;
  final TextInputType? keyboardType;

  static OutlineInputBorder _border(Color color, double width) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: color, width: width),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        QuestionnaireRequiredLabel(label: label, required: required),
        8.vertical,
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: context.contentRegular.copyWith(color: AppColors.neutral1000),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: context.contentRegular.copyWith(
              color: AppColors.neutral400,
            ),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            enabledBorder: _border(AppColors.neutral400, 1),
            focusedBorder: _border(AppColors.primary500, 1.5),
          ),
        ),
      ],
    );
  }
}
