import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/num_spacing_extension.dart';
import '../../cubits/questionnaire/questionnaire_cubit.dart';
import '../questionnaire_step_title.dart';
import '../questionnaire_unit_field.dart';
import '../../../../../core/l10n/l10n_extension.dart';

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
        QuestionnaireStepTitle(
          title: context.l10n.measurements,
          subtitle: context.l10n.measurementsCmOptionalPhotos,
        ),
        16.vertical,
        QuestionnaireUnitField(
          label: context.l10n.bodyFatPercentageIfAny,
          unit: '%',
          hint: context.l10n.enterBodyFatPercentage,
          controller: bodyFatCtrl,
          onChanged: cubit.updateBodyFat,
        ),
        16.vertical,
        QuestionnaireUnitField(
          label: context.l10n.waistCircumference,
          unit: context.l10n.unitCm,
          hint: context.l10n.enterWaistCircumference,
          controller: waistCtrl,
          onChanged: cubit.updateWaist,
        ),
        16.vertical,
        QuestionnaireUnitField(
          label: context.l10n.chestCircumference,
          unit: context.l10n.unitCm,
          hint: context.l10n.enterChestCircumference,
          controller: chestCtrl,
          onChanged: cubit.updateChest,
        ),
        16.vertical,
        QuestionnaireUnitField(
          label: context.l10n.armCircumference,
          unit: context.l10n.unitCm,
          hint: context.l10n.enterArmCircumference,
          controller: armCtrl,
          onChanged: cubit.updateArm,
        ),
        16.vertical,
        QuestionnaireUnitField(
          label: context.l10n.thighCircumference,
          unit: context.l10n.unitCm,
          hint: context.l10n.enterThighCircumference,
          controller: thighCtrl,
          onChanged: cubit.updateThigh,
        ),
      ],
    );
  }
}
