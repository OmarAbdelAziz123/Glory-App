import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/num_spacing_extension.dart';
import '../../../../../core/utils/onboarding_utils.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../cubits/questionnaire/questionnaire_cubit.dart';
import '../questionnaire_choice_chip.dart';
import '../questionnaire_required_label.dart';
import '../questionnaire_step_title.dart';
import '../questionnaire_text_field.dart';
import '../questionnaire_unit_field.dart';
import 'package:glory_gym/core/l10n/l10n.dart';

final class PersonalDataStep extends StatelessWidget {
  const PersonalDataStep({
    super.key,
    required this.fullNameCtrl,
    required this.ageCtrl,
    required this.professionCtrl,
    required this.phoneCtrl,
    this.phoneFieldKey,
  });

  final TextEditingController fullNameCtrl;
  final TextEditingController ageCtrl;
  final TextEditingController professionCtrl;
  final TextEditingController phoneCtrl;
  final GlobalKey<AppPhoneFieldState>? phoneFieldKey;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuestionnaireCubit>();
    final gender = context.select((QuestionnaireCubit c) => c.state.gender);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        QuestionnaireStepTitle(
          title: context.l10n.personalData,
          subtitle: context.l10n.subscriberBasicInfoSubtitle,
        ),
        16.vertical,
        QuestionnaireTextField(
          label: context.l10n.fullName,
          hint: context.l10n.enterFullName,
          controller: fullNameCtrl,
          onChanged: cubit.updateFullName,
        ),
        16.vertical,
        QuestionnaireUnitField(
          label: context.l10n.age,
          unit: context.l10n.year,
          hint: context.l10n.enterYourAge,
          controller: ageCtrl,
          onChanged: cubit.updateAge,
        ),
        16.vertical,
        QuestionnaireRequiredLabel(label: context.l10n.gender),
        8.vertical,
        Row(
          children: [
            for (final entry
                in OnboardingUtils.genderLabels(context.l10n).entries) ...[
              if (entry.key !=
                  OnboardingUtils.genderLabels(context.l10n).keys.first)
                const SizedBox(width: 12),
              QuestionnaireChoiceChip(
                label: entry.value,
                selected: gender == entry.key,
                onTap: () => cubit.updateGender(entry.key),
                expanded: true,
              ),
            ],
          ],
        ),
        16.vertical,
        AppPhoneField(
          key: phoneFieldKey,
          label: context.l10n.phoneRequired,
          hint: context.l10n.enterYourPhone,
          controller: phoneCtrl,
          initialDialCode: context.select(
            (QuestionnaireCubit c) => c.state.phoneCountryCode,
          ),
          onChanged: cubit.updatePhone,
        ),
        16.vertical,
        QuestionnaireTextField(
          label: context.l10n.occupation,
          hint: context.l10n.enterOccupation,
          controller: professionCtrl,
          onChanged: cubit.updateProfession,
        ),
      ],
    );
  }
}
