import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/num_spacing_extension.dart';
import '../../../../../core/utils/onboarding_utils.dart';
import '../../cubits/questionnaire/questionnaire_cubit.dart';
import '../questionnaire_choice_chip.dart';
import '../questionnaire_required_label.dart';
import '../questionnaire_step_title.dart';
import '../questionnaire_unit_field.dart';
import 'package:glory_gym/core/l10n/l10n.dart';

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
        QuestionnaireStepTitle(
          title: context.l10n.lifestyle,
          subtitle: context.l10n.recoveryFactorsSubtitle,
        ),
        16.vertical,
        QuestionnaireUnitField(
          label: context.l10n.sleepHoursCount,
          unit: context.l10n.hour,
          hint: context.l10n.enterNumberOfHours,
          controller: sleepCtrl,
          onChanged: cubit.updateSleepHours,
        ),
        16.vertical,
        QuestionnaireRequiredLabel(label: context.l10n.natureOfWork),
        8.vertical,
        Row(
          children: [
            for (final entry
                in OnboardingUtils.workNatureOptions(context.l10n).entries) ...[
              if (entry.key !=
                  OnboardingUtils.workNatureOptions(context.l10n).keys.first)
                const SizedBox(width: 12),
              QuestionnaireChoiceChip(
                label: entry.value,
                selected: workNature == entry.key,
                onTap: () => cubit.updateWorkNature(entry.key),
                expanded: true,
              ),
            ],
          ],
        ),
        16.vertical,
        QuestionnaireRequiredLabel(label: context.l10n.stressLevel),
        8.vertical,
        Row(
          children: [
            for (final entry
                in OnboardingUtils.stressOptions(context.l10n).entries) ...[
              if (entry.key !=
                  OnboardingUtils.stressOptions(context.l10n).keys.first)
                const SizedBox(width: 12),
              QuestionnaireChoiceChip(
                label: entry.value,
                selected: stressLevel == entry.key,
                onTap: () => cubit.updateStressLevel(entry.key),
                expanded: true,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
