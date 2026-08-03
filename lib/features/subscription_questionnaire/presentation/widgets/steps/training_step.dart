import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/num_spacing_extension.dart';
import '../../cubits/questionnaire/questionnaire_cubit.dart';
import '../questionnaire_choice_chip.dart';
import '../questionnaire_required_label.dart';
import '../questionnaire_step_title.dart';
import '../questionnaire_text_area.dart';
import '../questionnaire_unit_field.dart';
import '../questionnaire_yes_no_field.dart';

final class TrainingStep extends StatelessWidget {
  const TrainingStep({
    super.key,
    required this.daysCtrl,
    required this.trainerCtrl,
  });

  final TextEditingController daysCtrl;
  final TextEditingController trainerCtrl;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuestionnaireCubit>();
    final preferredTime =
        context.select((QuestionnaireCubit c) => c.state.preferredTime);
    final preferredExercises =
        context.select((QuestionnaireCubit c) => c.state.preferredExercises);
    final trained = context
        .select((QuestionnaireCubit c) => c.state.trainedWithPersonalTrainer);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const QuestionnaireStepTitle(
          title: 'معلومات التدريب',
          subtitle: 'لتحديد جدول التدريب المناسب لك.',
        ),
        16.vertical,
        QuestionnaireUnitField(
          label: 'عدد الأيام التي تستطيع الالتزام بها أسبوعياً',
          unit: 'يوم',
          hint: 'قم بإدخال عدد الأيام',
          controller: daysCtrl,
          onChanged: cubit.updateCommitmentDays,
        ),
        16.vertical,
        const QuestionnaireRequiredLabel(label: 'الوقت المفضل للتمرين'),
        8.vertical,
        Row(
          children: [
            for (var i = 0;
                i < QuestionnaireCubit.timeOptions.length;
                i++) ...[
              if (i > 0) const SizedBox(width: 12),
              QuestionnaireChoiceChip(
                label: QuestionnaireCubit.timeOptions[i],
                selected: preferredTime == QuestionnaireCubit.timeOptions[i],
                onTap: () => cubit.updatePreferredTime(
                  QuestionnaireCubit.timeOptions[i],
                ),
                expanded: true,
              ),
            ],
          ],
        ),
        16.vertical,
        const QuestionnaireRequiredLabel(label: 'التمارين المفضلة'),
        8.vertical,
        Row(
          children: [
            for (var i = 0;
                i < QuestionnaireCubit.preferredExerciseOptions.length;
                i++) ...[
              if (i > 0) const SizedBox(width: 12),
              QuestionnaireChoiceChip(
                label: QuestionnaireCubit.preferredExerciseOptions[i],
                selected: preferredExercises ==
                    QuestionnaireCubit.preferredExerciseOptions[i],
                onTap: () => cubit.updatePreferredExercises(
                  QuestionnaireCubit.preferredExerciseOptions[i],
                ),
                expanded: true,
              ),
            ],
          ],
        ),
        16.vertical,
        QuestionnaireYesNoField(
          label: 'هل سبق أن تدربت مع مدرب شخصي؟',
          value: trained,
          onChanged: cubit.updateTrainedWithPersonalTrainer,
        ),
        if (trained == true) ...[
          8.vertical,
          QuestionnaireTextArea(
            label: 'التفاصيل',
            hint: 'اذكر مدة التدريب مع المدرب الشخصي',
            controller: trainerCtrl,
            onChanged: cubit.updatePersonalTrainerDetails,
            required: true,
          ),
        ],
      ],
    );
  }
}
