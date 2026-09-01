import 'package:flutter/material.dart';

import '../../../../core/extensions/num_spacing_extension.dart';
import 'questionnaire_choice_chip.dart';
import 'questionnaire_required_label.dart';
import '../../../../core/l10n/l10n_extension.dart';

final class QuestionnaireYesNoField extends StatelessWidget {
  const QuestionnaireYesNoField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.required = true,
  });

  final String label;
  final bool? value;
  final ValueChanged<bool> onChanged;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        QuestionnaireRequiredLabel(label: label, required: required),
        8.vertical,
        Row(
          children: [
            QuestionnaireChoiceChip(
              label: context.l10n.yes,
              selected: value == true,
              onTap: () => onChanged(true),
              expanded: true,
            ),
            const SizedBox(width: 12),
            QuestionnaireChoiceChip(
              label: context.l10n.no,
              selected: value == false,
              onTap: () => onChanged(false),
              expanded: true,
            ),
          ],
        ),
      ],
    );
  }
}
