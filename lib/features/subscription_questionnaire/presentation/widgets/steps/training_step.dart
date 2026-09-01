import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/num_spacing_extension.dart';
import '../../../../../core/utils/onboarding_utils.dart';
import '../../cubits/questionnaire/questionnaire_cubit.dart';
import '../questionnaire_choice_chip.dart';
import '../questionnaire_required_label.dart';
import '../questionnaire_step_title.dart';
import '../questionnaire_text_area.dart';
import '../questionnaire_unit_field.dart';
import '../questionnaire_yes_no_field.dart';
import 'package:glory_gym/core/l10n/l10n.dart';

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
        QuestionnaireStepTitle(
          title: context.l10n.trainingInfo,
          subtitle: context.l10n.toDetermineTrainingSchedule,
        ),
        16.vertical,
        QuestionnaireUnitField(
          label: context.l10n.daysYouCanCommitWeekly,
          unit: context.l10n.day,
          hint: context.l10n.enterNumberOfDays,
          controller: daysCtrl,
          onChanged: cubit.updateCommitmentDays,
        ),
        16.vertical,
        QuestionnaireRequiredLabel(label: context.l10n.preferredWorkoutTime),
        8.vertical,
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final entry in OnboardingUtils.timeOptions(context.l10n).entries)
              QuestionnaireChoiceChip(
                label: entry.value,
                selected: preferredTime == entry.key,
                onTap: () => cubit.updatePreferredTime(entry.key),
              ),
          ],
        ),
        16.vertical,
        QuestionnaireRequiredLabel(label: context.l10n.favoriteWorkouts),
        8.vertical,
        Row(
          children: [
            for (final entry
                in OnboardingUtils.preferredExerciseOptions(context.l10n)
                    .entries) ...[
              if (entry.key !=
                  OnboardingUtils.preferredExerciseOptions(context.l10n)
                      .keys
                      .first)
                const SizedBox(width: 12),
              QuestionnaireChoiceChip(
                label: entry.value,
                selected: preferredExercises == entry.key,
                onTap: () => cubit.updatePreferredExercises(entry.key),
                expanded: true,
              ),
            ],
          ],
        ),
        16.vertical,
        QuestionnaireYesNoField(
          label: context.l10n.trainedWithPersonalCoachQuestion,
          value: trained,
          onChanged: cubit.updateTrainedWithPersonalTrainer,
        ),
        if (trained == true) ...[
          8.vertical,
          QuestionnaireTextArea(
            label: context.l10n.details,
            hint: context.l10n.mentionDurationAndPreviousProgram,
            controller: trainerCtrl,
            onChanged: cubit.updatePersonalTrainerDetails,
            required: true,
          ),
        ],
      ],
    );
  }
}
