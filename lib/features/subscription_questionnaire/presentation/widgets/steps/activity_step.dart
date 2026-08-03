import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/num_spacing_extension.dart';
import '../../cubits/questionnaire/questionnaire_cubit.dart';
import '../questionnaire_step_title.dart';
import '../questionnaire_text_field.dart';
import '../questionnaire_unit_field.dart';
import '../questionnaire_yes_no_field.dart';

final class ActivityStep extends StatelessWidget {
  const ActivityStep({
    super.key,
    required this.daysCtrl,
    required this.typesCtrl,
    required this.durationCtrl,
  });

  final TextEditingController daysCtrl;
  final TextEditingController typesCtrl;
  final TextEditingController durationCtrl;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuestionnaireCubit>();
    final exercises =
        context.select((QuestionnaireCubit c) => c.state.exercisesCurrently);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const QuestionnaireStepTitle(
          title: 'النشاط البدني الحالي',
          subtitle: 'مستوى نشاطك في الوقت الراهن.',
        ),
        16.vertical,
        QuestionnaireYesNoField(
          label: 'هل تمارس الرياضة حالياً؟',
          value: exercises,
          onChanged: cubit.updateExercisesCurrently,
        ),
        if (exercises == true) ...[
          16.vertical,
          QuestionnaireUnitField(
            label: 'عدد أيام التمرين في الأسبوع',
            unit: 'يوم',
            hint: 'قم بإدخال عدد الأيام',
            controller: daysCtrl,
            onChanged: cubit.updateExerciseDaysPerWeek,
          ),
          16.vertical,
          QuestionnaireTextField(
            label: 'نوع التمارين',
            hint: 'مثال: أوزان، كارديو، سباحة',
            controller: typesCtrl,
            onChanged: cubit.updateExerciseTypes,
            required: false,
          ),
          16.vertical,
          QuestionnaireTextField(
            label: 'منذ متى تتمرن؟',
            hint: 'مثال: سنة وثلاثة أشهر',
            controller: durationCtrl,
            onChanged: cubit.updateExerciseDuration,
            required: false,
          ),
        ],
      ],
    );
  }
}
