import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/num_spacing_extension.dart';
import '../../cubits/questionnaire/questionnaire_cubit.dart';
import '../questionnaire_step_title.dart';
import '../questionnaire_unit_field.dart';

final class MeasurementsStep extends StatelessWidget {
  const MeasurementsStep({
    super.key,
    required this.bodyFatCtrl,
    required this.waistCtrl,
    required this.chestCtrl,
    required this.armCtrl,
    required this.thighCtrl,
  });

  final TextEditingController bodyFatCtrl;
  final TextEditingController waistCtrl;
  final TextEditingController chestCtrl;
  final TextEditingController armCtrl;
  final TextEditingController thighCtrl;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuestionnaireCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const QuestionnaireStepTitle(
          title: 'القياسات',
          subtitle: 'القياسات الحالية بوحدة السنتيمتر. الصور اختيارية.',
        ),
        16.vertical,
        QuestionnaireUnitField(
          label: 'نسبة الدهون (إن وجدت)',
          unit: '%',
          hint: 'قم بإدخال نسبة الدهون',
          controller: bodyFatCtrl,
          onChanged: cubit.updateBodyFat,
        ),
        16.vertical,
        QuestionnaireUnitField(
          label: 'محيط الخصر',
          unit: 'سم',
          hint: 'قم بإدخال محيط الخصر',
          controller: waistCtrl,
          onChanged: cubit.updateWaist,
        ),
        16.vertical,
        QuestionnaireUnitField(
          label: 'محيط الصدر',
          unit: 'سم',
          hint: 'قم بإدخال محيط الصدر',
          controller: chestCtrl,
          onChanged: cubit.updateChest,
        ),
        16.vertical,
        QuestionnaireUnitField(
          label: 'محيط الذراع',
          unit: 'سم',
          hint: 'قم بإدخال محيط الذراع',
          controller: armCtrl,
          onChanged: cubit.updateArm,
        ),
        16.vertical,
        QuestionnaireUnitField(
          label: 'محيط الفخذ',
          unit: 'سم',
          hint: 'قم بإدخال محيط الفخذ',
          controller: thighCtrl,
          onChanged: cubit.updateThigh,
        ),
      ],
    );
  }
}
