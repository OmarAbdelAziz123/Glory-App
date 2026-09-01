import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/num_spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/onboarding_utils.dart';
import '../../../../../core/theme/app_styles_extension.dart';
import '../../cubits/questionnaire/questionnaire_cubit.dart';
import '../questionnaire_choice_chip.dart';
import '../questionnaire_required_label.dart';
import '../questionnaire_step_title.dart';
import '../questionnaire_text_area.dart';
import 'package:glory_gym/core/l10n/l10n.dart';

final class GoalsStep extends StatelessWidget {
  const GoalsStep({super.key, required this.otherGoalCtrl});

  final TextEditingController otherGoalCtrl;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuestionnaireCubit>();
    final goals = context.select((QuestionnaireCubit c) => c.state.goals);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        QuestionnaireStepTitle(
          title: context.l10n.subscriptionGoal,
          subtitle: context.l10n.multipleGoalsAllowed,
        ),
        16.vertical,
        QuestionnaireRequiredLabel(
          label: context.l10n.whatDoYouWantToAchieve,
          trailing: Text(
            context.l10n.multiSelect,
            style: context.captionRegular.copyWith(color: AppColors.neutral400),
          ),
        ),
        8.vertical,
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.start,
          children: [
            for (final entry in OnboardingUtils.goalOptions(context.l10n).entries)
              QuestionnaireChoiceChip(
                label: entry.value,
                selected: goals.contains(entry.key),
                onTap: () => cubit.toggleGoal(entry.key),
              ),
          ],
        ),
        16.vertical,
        QuestionnaireTextArea(
          label: context.l10n.otherGoal,
          hint: context.l10n.writeAdditionalGoalIfAny,
          controller: otherGoalCtrl,
          onChanged: cubit.updateOtherGoal,
        ),
      ],
    );
  }
}
