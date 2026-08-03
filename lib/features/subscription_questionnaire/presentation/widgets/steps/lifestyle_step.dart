import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/num_spacing_extension.dart';
import '../../cubits/questionnaire/questionnaire_cubit.dart';
import '../questionnaire_choice_chip.dart';
import '../questionnaire_required_label.dart';
import '../questionnaire_step_title.dart';
import '../questionnaire_unit_field.dart';

final class LifestyleStep extends StatelessWidget {
  const LifestyleStep({super.key, required this.sleepCtrl});

  final TextEditingController sleepCtrl;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuestionnaireCubit>();
    final workNature =
        context.select((QuestionnaireCubit c) => c.state.workNature);
    final stressLevel =
        context.select((QuestionnaireCubit c) => c.state.stressLevel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const QuestionnaireStepTitle(
          title: 'نمط الحياة',
          subtitle: 'العوامل المؤثرة على الاستشفاء والنتائج.',
        ),
        16.vertical,
        QuestionnaireUnitField(
          label: 'عدد ساعات النوم',
          unit: 'ساعة',
          hint: 'قم بإدخال عدد الساعات',
          controller: sleepCtrl,
          onChanged: cubit.updateSleepHours,
        ),
        16.vertical,
        const QuestionnaireRequiredLabel(label: 'طبيعة العمل'),
        8.vertical,
        Row(
          children: [
            for (var i = 0;
                i < QuestionnaireCubit.workNatureOptions.length;
                i++) ...[
              if (i > 0) const SizedBox(width: 12),
              QuestionnaireChoiceChip(
                label: QuestionnaireCubit.workNatureOptions[i],
                selected:
                    workNature == QuestionnaireCubit.workNatureOptions[i],
                onTap: () => cubit.updateWorkNature(
                  QuestionnaireCubit.workNatureOptions[i],
                ),
                expanded: true,
              ),
            ],
          ],
        ),
        16.vertical,
        const QuestionnaireRequiredLabel(label: 'مستوى التوتر'),
        8.vertical,
        Row(
          children: [
            for (var i = 0;
                i < QuestionnaireCubit.stressOptions.length;
                i++) ...[
              if (i > 0) const SizedBox(width: 12),
              QuestionnaireChoiceChip(
                label: QuestionnaireCubit.stressOptions[i],
                selected: stressLevel == QuestionnaireCubit.stressOptions[i],
                onTap: () => cubit.updateStressLevel(
                  QuestionnaireCubit.stressOptions[i],
                ),
                expanded: true,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
