import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/num_spacing_extension.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../cubits/questionnaire/questionnaire_cubit.dart';
import '../questionnaire_choice_chip.dart';
import '../questionnaire_required_label.dart';
import '../questionnaire_step_title.dart';
import '../questionnaire_text_field.dart';
import '../questionnaire_unit_field.dart';

final class PersonalDataStep extends StatelessWidget {
  const PersonalDataStep({
    super.key,
    required this.fullNameCtrl,
    required this.ageCtrl,
    required this.professionCtrl,
    required this.phoneCtrl,
  });

  final TextEditingController fullNameCtrl;
  final TextEditingController ageCtrl;
  final TextEditingController professionCtrl;
  final TextEditingController phoneCtrl;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuestionnaireCubit>();
    final gender = context.select((QuestionnaireCubit c) => c.state.gender);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const QuestionnaireStepTitle(
          title: 'البيانات الشخصية',
          subtitle: 'المعلومات الأساسية الخاصة بالمشترك.',
        ),
        16.vertical,
        QuestionnaireTextField(
          label: 'الاسم الكامل',
          hint: 'قم بإدخال الاسم الكامل',
          controller: fullNameCtrl,
          onChanged: cubit.updateFullName,
        ),
        16.vertical,
        QuestionnaireUnitField(
          label: 'العمر',
          unit: 'سنة',
          hint: 'قم بإدخال العمر الخاص بك',
          controller: ageCtrl,
          onChanged: cubit.updateAge,
        ),
        16.vertical,
        const QuestionnaireRequiredLabel(label: 'الجنس'),
        8.vertical,
        Row(
          children: [
            QuestionnaireChoiceChip(
              label: 'ذكر',
              selected: gender == 'ذكر',
              onTap: () => cubit.updateGender('ذكر'),
              expanded: true,
            ),
            const SizedBox(width: 12),
            QuestionnaireChoiceChip(
              label: 'أنثى',
              selected: gender == 'أنثى',
              onTap: () => cubit.updateGender('أنثى'),
              expanded: true,
            ),
          ],
        ),
        16.vertical,
        AppPhoneField(
          label: 'رقم الهاتف *',
          hint: 'قم بإدخال رقم الهاتف الخاصة بك',
          controller: phoneCtrl,
          onChanged: cubit.updatePhone,
        ),
        16.vertical,
        QuestionnaireTextField(
          label: 'المهنة',
          hint: 'قم بإدخال المهنة',
          controller: professionCtrl,
          onChanged: cubit.updateProfession,
        ),
      ],
    );
  }
}
