import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/num_spacing_extension.dart';
import '../../cubits/questionnaire/questionnaire_cubit.dart';
import '../questionnaire_step_title.dart';
import '../questionnaire_text_area.dart';
import '../questionnaire_unit_field.dart';
import '../questionnaire_yes_no_field.dart';

final class NutritionStep extends StatelessWidget {
  const NutritionStep({
    super.key,
    required this.mealsCtrl,
    required this.waterCtrl,
    required this.supplementsCtrl,
  });

  final TextEditingController mealsCtrl;
  final TextEditingController waterCtrl;
  final TextEditingController supplementsCtrl;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuestionnaireCubit>();
    final state = context.watch<QuestionnaireCubit>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const QuestionnaireStepTitle(
          title: 'التغذية',
          subtitle: 'عاداتك الغذائية اليومية.',
        ),
        16.vertical,
        QuestionnaireYesNoField(
          label: 'هل تتبع نظاماً غذائياً؟',
          value: state.followsDiet,
          onChanged: cubit.updateFollowsDiet,
        ),
        16.vertical,
        QuestionnaireUnitField(
          label: 'عدد الوجبات اليومية',
          unit: 'وجبة',
          hint: 'قم بإدخال عدد الوجبات',
          controller: mealsCtrl,
          onChanged: cubit.updateMealsPerDay,
        ),
        16.vertical,
        QuestionnaireUnitField(
          label: 'كمية الماء اليومية',
          unit: 'لتر',
          hint: 'قم بإدخال كمية الماء',
          controller: waterCtrl,
          onChanged: cubit.updateWaterLiters,
        ),
        16.vertical,
        QuestionnaireYesNoField(
          label: 'هل تستخدم مكملات غذائية؟',
          value: state.usesSupplements,
          onChanged: cubit.updateUsesSupplements,
        ),
        if (state.usesSupplements == true) ...[
          8.vertical,
          QuestionnaireTextArea(
            label: 'التفاصيل',
            hint: 'اذكر المكملات الغذائية',
            controller: supplementsCtrl,
            onChanged: cubit.updateSupplementsDetails,
            required: true,
          ),
        ],
      ],
    );
  }
}
