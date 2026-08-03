import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/num_spacing_extension.dart';
import '../../cubits/questionnaire/questionnaire_cubit.dart';
import '../questionnaire_step_title.dart';
import '../questionnaire_text_area.dart';
import '../questionnaire_yes_no_field.dart';

final class MedicalHistoryStep extends StatelessWidget {
  const MedicalHistoryStep({
    super.key,
    required this.chronicCtrl,
    required this.medicationsCtrl,
    required this.injuriesCtrl,
    required this.surgeryCtrl,
  });

  final TextEditingController chronicCtrl;
  final TextEditingController medicationsCtrl;
  final TextEditingController injuriesCtrl;
  final TextEditingController surgeryCtrl;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuestionnaireCubit>();
    final state = context.watch<QuestionnaireCubit>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const QuestionnaireStepTitle(
          title: 'التاريخ الصحي',
          subtitle: 'استبيان الجاهزية البدنية (PAR-Q). يُرجى الإجابة بدقة.',
        ),
        16.vertical,
        QuestionnaireYesNoField(
          label: 'هل لديك أي مرض مزمن؟ (سكري، ضغط، قلب…)',
          value: state.hasChronicDisease,
          onChanged: cubit.updateHasChronicDisease,
        ),
        if (state.hasChronicDisease == true) ...[
          8.vertical,
          QuestionnaireTextArea(
            label: 'التفاصيل',
            hint: 'اذكر المرض المزمن',
            controller: chronicCtrl,
            onChanged: cubit.updateChronicDiseaseDetails,
            required: true,
          ),
        ],
        16.vertical,
        QuestionnaireYesNoField(
          label: 'هل تتناول أي أدوية بشكل دائم؟',
          value: state.hasMedications,
          onChanged: cubit.updateHasMedications,
        ),
        if (state.hasMedications == true) ...[
          8.vertical,
          QuestionnaireTextArea(
            label: 'التفاصيل',
            hint: 'اذكر الأدوية التي تتناولها',
            controller: medicationsCtrl,
            onChanged: cubit.updateMedicationsDetails,
            required: true,
          ),
        ],
        16.vertical,
        QuestionnaireYesNoField(
          label: 'هل لديك أي إصابات حالية أو سابقة؟',
          value: state.hasInjuries,
          onChanged: cubit.updateHasInjuries,
        ),
        if (state.hasInjuries == true) ...[
          8.vertical,
          QuestionnaireTextArea(
            label: 'التفاصيل',
            hint: 'اذكر موضع الإصابة وتاريخها',
            controller: injuriesCtrl,
            onChanged: cubit.updateInjuriesDetails,
            required: true,
          ),
        ],
        16.vertical,
        QuestionnaireYesNoField(
          label: 'هل أجريت أي عملية جراحية؟',
          value: state.hasSurgery,
          onChanged: cubit.updateHasSurgery,
        ),
        if (state.hasSurgery == true) ...[
          8.vertical,
          QuestionnaireTextArea(
            label: 'التفاصيل',
            hint: 'اذكر العملية الجراحية وتاريخها',
            controller: surgeryCtrl,
            onChanged: cubit.updateSurgeryDetails,
            required: true,
          ),
        ],
      ],
    );
  }
}
