import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/num_spacing_extension.dart';
import '../../cubits/questionnaire/questionnaire_cubit.dart';
import '../questionnaire_step_title.dart';
import '../questionnaire_text_field.dart';
import '../questionnaire_unit_field.dart';
import '../questionnaire_yes_no_field.dart';
import '../../../../../core/l10n/l10n_extension.dart';

final class ActivityStep extends StatelessWidget {
  const ActivityStep({
    super.key,
    required this.daysCtrl,
    required this.typesCtrl,
    required this.durationCtrl,
  });

  final TextEditingController daysCtrl;
  final TextEditingController typesCtrl;
  final TextEditingController durationCtrl;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuestionnaireCubit>();
    final exercises =
        context.select((QuestionnaireCubit c) => c.state.exercisesCurrently);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        QuestionnaireStepTitle(
          title: context.l10n.currentPhysicalActivity,
          subtitle: context.l10n.currentActivityLevelSubtitle,
        ),
        16.vertical,
        QuestionnaireYesNoField(
          label: context.l10n.currentlyExercisingQuestion,
          value: exercises,
          onChanged: cubit.updateExercisesCurrently,
        ),
        16.vertical,
        QuestionnaireUnitField(
          label: context.l10n.workoutDaysPerWeek,
          unit: context.l10n.day,
          hint: context.l10n.enterNumberOfDays,
          controller: daysCtrl,
          onChanged: cubit.updateExerciseDaysPerWeek,
          required: exercises == true,
        ),
        16.vertical,
        QuestionnaireTextField(
          label: context.l10n.workoutTypes,
          hint: context.l10n.exampleWeightsCardioSwimming,
          controller: typesCtrl,
          onChanged: cubit.updateExerciseTypes,
          required: false,
        ),
        16.vertical,
        QuestionnaireTextField(
          label: context.l10n.howLongHaveYouBeenTraining,
          hint: context.l10n.exampleOneYearThreeMonths,
          controller: durationCtrl,
          onChanged: cubit.updateExerciseDuration,
          required: false,
        ),
      ],
    );
  }
}
