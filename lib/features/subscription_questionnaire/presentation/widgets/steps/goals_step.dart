import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/num_spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles_extension.dart';
import '../../cubits/questionnaire/questionnaire_cubit.dart';
import '../questionnaire_choice_chip.dart';
import '../questionnaire_required_label.dart';
import '../questionnaire_step_title.dart';
import '../questionnaire_text_area.dart';

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
        const QuestionnaireStepTitle(
          title: 'الهدف من الاشتراك',
          subtitle: 'يمكن اختيار أكثر من هدف واحد.',
        ),
        16.vertical,
        QuestionnaireRequiredLabel(
          label: 'ما الذي تسعى إلى تحقيقه؟',
          trailing: Text(
            'اختيار متعدد',
            style: context.captionRegular.copyWith(color: AppColors.neutral400),
          ),
        ),
        8.vertical,
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.start,
          children: [
            for (final goal in QuestionnaireCubit.goalOptions)
              QuestionnaireChoiceChip(
                label: goal,
                selected: goals.contains(goal),
                onTap: () => cubit.toggleGoal(goal),
              ),
          ],
        ),
        16.vertical,
        QuestionnaireTextArea(
          label: 'هدف آخر',
          hint: 'اكتب هدفاً إضافياً إن وجد',
          controller: otherGoalCtrl,
          onChanged: cubit.updateOtherGoal,
        ),
      ],
    );
  }
}
