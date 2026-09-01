import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/num_spacing_extension.dart';
import '../../cubits/questionnaire/questionnaire_cubit.dart';
import '../questionnaire_step_title.dart';
import '../questionnaire_text_area.dart';
import '../questionnaire_yes_no_field.dart';
import '../../../../../core/l10n/l10n_extension.dart';

final class MedicalHistoryStep extends StatelessWidget {
  const MedicalHistoryStep({
    super.key,
    required this.injuriesCtrl,
    required this.surgeryCtrl,
  });

  final TextEditingController injuriesCtrl;
  final TextEditingController surgeryCtrl;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuestionnaireCubit>();
    final state = context.watch<QuestionnaireCubit>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        QuestionnaireStepTitle(
          title: context.l10n.healthHistory,
          subtitle: context.l10n.parqQuestionnaireIntro,
        ),
        16.vertical,
        QuestionnaireYesNoField(
          label: context.l10n.haveChronicDiseaseQuestion,
          value: state.hasChronicDisease,
          onChanged: cubit.updateHasChronicDisease,
        ),
        16.vertical,
        QuestionnaireYesNoField(
          label: context.l10n.takeMedicationsQuestion,
          value: state.hasMedications,
          onChanged: cubit.updateHasMedications,
        ),
        16.vertical,
        QuestionnaireYesNoField(
          label: context.l10n.haveInjuriesQuestion,
          value: state.hasInjuries,
          onChanged: cubit.updateHasInjuries,
        ),
        if (state.hasInjuries == true) ...[
          8.vertical,
          QuestionnaireTextArea(
            label: context.l10n.details,
            hint: context.l10n.mentionInjuryLocationAndDate,
            controller: injuriesCtrl,
            onChanged: cubit.updateInjuriesDetails,
            required: true,
          ),
        ],
        16.vertical,
        QuestionnaireYesNoField(
          label: context.l10n.hadSurgeryQuestion,
          value: state.hasSurgery,
          onChanged: cubit.updateHasSurgery,
        ),
        if (state.hasSurgery == true) ...[
          8.vertical,
          QuestionnaireTextArea(
            label: context.l10n.details,
            hint: context.l10n.surgeryDetails,
            controller: surgeryCtrl,
            onChanged: cubit.updateSurgeryDetails,
            required: true,
          ),
        ],
      ],
    );
  }
}
