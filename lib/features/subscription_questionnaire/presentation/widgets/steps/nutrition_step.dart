import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/num_spacing_extension.dart';
import '../../cubits/questionnaire/questionnaire_cubit.dart';
import '../questionnaire_step_title.dart';
import '../questionnaire_unit_field.dart';
import '../questionnaire_yes_no_field.dart';
import '../../../../../core/l10n/l10n_extension.dart';

final class NutritionStep extends StatelessWidget {
  const NutritionStep({
    super.key,
    required this.mealsCtrl,
    required this.waterCtrl,
  });

  final TextEditingController mealsCtrl;
  final TextEditingController waterCtrl;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuestionnaireCubit>();
    final state = context.watch<QuestionnaireCubit>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        QuestionnaireStepTitle(
          title: context.l10n.nutrition,
          subtitle: context.l10n.dailyNutritionHabitsSubtitle,
        ),
        16.vertical,
        QuestionnaireYesNoField(
          label: context.l10n.followDietQuestion,
          value: state.followsDiet,
          onChanged: cubit.updateFollowsDiet,
        ),
        16.vertical,
        QuestionnaireUnitField(
          label: context.l10n.dailyMealsCount,
          unit: context.l10n.meal,
          hint: context.l10n.enterNumberOfMeals,
          controller: mealsCtrl,
          onChanged: cubit.updateMealsPerDay,
        ),
        16.vertical,
        QuestionnaireUnitField(
          label: context.l10n.dailyWaterIntake,
          unit: context.l10n.liter,
          hint: context.l10n.enterWaterAmount,
          controller: waterCtrl,
          onChanged: cubit.updateWaterLiters,
        ),
        16.vertical,
        QuestionnaireYesNoField(
          label: context.l10n.useSupplementsQuestion,
          value: state.usesSupplements,
          onChanged: cubit.updateUsesSupplements,
        ),
      ],
    );
  }
}
