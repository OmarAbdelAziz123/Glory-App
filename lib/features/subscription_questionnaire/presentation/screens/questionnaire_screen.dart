import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubits/questionnaire/questionnaire_cubit.dart';
import '../widgets/questionnaire_header.dart';
import '../widgets/steps/activity_step.dart';
import '../widgets/steps/goals_step.dart';
import '../widgets/steps/lifestyle_step.dart';
import '../widgets/steps/measurements_step.dart';
import '../widgets/steps/medical_history_step.dart';
import '../widgets/steps/nutrition_step.dart';
import '../widgets/steps/personal_data_step.dart';
import '../widgets/steps/training_step.dart';

final class QuestionnaireScreen extends StatelessWidget {
  const QuestionnaireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuestionnaireCubit(),
      child: const _QuestionnaireView(),
    );
  }
}

final class _QuestionnaireView extends StatefulWidget {
  const _QuestionnaireView();

  @override
  State<_QuestionnaireView> createState() => _QuestionnaireViewState();
}

final class _QuestionnaireViewState extends State<_QuestionnaireView> {
  final _pageController = PageController();

  final _fullNameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _professionCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _otherGoalCtrl = TextEditingController();
  final _chronicCtrl = TextEditingController();
  final _medicationsCtrl = TextEditingController();
  final _injuriesCtrl = TextEditingController();
  final _surgeryCtrl = TextEditingController();
  final _exerciseDaysCtrl = TextEditingController();
  final _exerciseTypesCtrl = TextEditingController();
  final _exerciseDurationCtrl = TextEditingController();
  final _mealsCtrl = TextEditingController();
  final _waterCtrl = TextEditingController();
  final _supplementsCtrl = TextEditingController();
  final _sleepCtrl = TextEditingController();
  final _bodyFatCtrl = TextEditingController();
  final _waistCtrl = TextEditingController();
  final _chestCtrl = TextEditingController();
  final _armCtrl = TextEditingController();
  final _thighCtrl = TextEditingController();
  final _commitmentDaysCtrl = TextEditingController();
  final _trainerCtrl = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _fullNameCtrl.dispose();
    _ageCtrl.dispose();
    _professionCtrl.dispose();
    _phoneCtrl.dispose();
    _otherGoalCtrl.dispose();
    _chronicCtrl.dispose();
    _medicationsCtrl.dispose();
    _injuriesCtrl.dispose();
    _surgeryCtrl.dispose();
    _exerciseDaysCtrl.dispose();
    _exerciseTypesCtrl.dispose();
    _exerciseDurationCtrl.dispose();
    _mealsCtrl.dispose();
    _waterCtrl.dispose();
    _supplementsCtrl.dispose();
    _sleepCtrl.dispose();
    _bodyFatCtrl.dispose();
    _waistCtrl.dispose();
    _chestCtrl.dispose();
    _armCtrl.dispose();
    _thighCtrl.dispose();
    _commitmentDaysCtrl.dispose();
    _trainerCtrl.dispose();
    super.dispose();
  }

  void _onBack(BuildContext context, QuestionnaireState state) {
    if (state.step > 0) {
      context.read<QuestionnaireCubit>().previousStep();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    Navigator.of(context).maybePop();
  }

  void _onNext(BuildContext context, QuestionnaireState state) {
    final cubit = context.read<QuestionnaireCubit>();
    if (!state.canProceed) return;

    if (state.isLastStep) {
      cubit.nextStep();
      return;
    }

    cubit.nextStep();
    _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _showSuccess(BuildContext context) {
    AppSuccessSheet.show(
      context,
      title: 'استبيان الاشتراك',
      headline: 'تم إرسال الاستبيان',
      highlightWord: 'تم إرسال الاستبيان_none',
      description:
          'شكراً لك. سيقوم المدرب بمراجعة بياناتك وإعداد خطة التدريب والتغذية المناسبة لك.',
      buttonLabel: 'الرئيسية',
      badgeAsset: 'assets/images/svgs/questionnaire_success_badge.svg',
      onButtonPressed: () {
        Navigator.of(context).pop();
        context.go(AppRoutes.login);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuestionnaireCubit, QuestionnaireState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status &&
          curr.status == QuestionnaireStatus.submitted,
      listener: (context, state) => _showSuccess(context),
      child: BlocBuilder<QuestionnaireCubit, QuestionnaireState>(
        builder: (context, state) {
          return PopScope(
            canPop: state.step == 0,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) _onBack(context, state);
            },
            child: AppScaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: AppColors.neutral100,
              appBar: QuestionnaireHeader(
                currentStep: state.step,
                totalSteps: QuestionnaireState.totalSteps,
                onBack: () => _onBack(context, state),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _StepScroll(
                          child: PersonalDataStep(
                            fullNameCtrl: _fullNameCtrl,
                            ageCtrl: _ageCtrl,
                            professionCtrl: _professionCtrl,
                            phoneCtrl: _phoneCtrl,
                          ),
                        ),
                        _StepScroll(
                          child: GoalsStep(otherGoalCtrl: _otherGoalCtrl),
                        ),
                        _StepScroll(
                          child: MedicalHistoryStep(
                            chronicCtrl: _chronicCtrl,
                            medicationsCtrl: _medicationsCtrl,
                            injuriesCtrl: _injuriesCtrl,
                            surgeryCtrl: _surgeryCtrl,
                          ),
                        ),
                        _StepScroll(
                          child: ActivityStep(
                            daysCtrl: _exerciseDaysCtrl,
                            typesCtrl: _exerciseTypesCtrl,
                            durationCtrl: _exerciseDurationCtrl,
                          ),
                        ),
                        _StepScroll(
                          child: NutritionStep(
                            mealsCtrl: _mealsCtrl,
                            waterCtrl: _waterCtrl,
                            supplementsCtrl: _supplementsCtrl,
                          ),
                        ),
                        _StepScroll(
                          child: LifestyleStep(sleepCtrl: _sleepCtrl),
                        ),
                        _StepScroll(
                          child: MeasurementsStep(
                            bodyFatCtrl: _bodyFatCtrl,
                            waistCtrl: _waistCtrl,
                            chestCtrl: _chestCtrl,
                            armCtrl: _armCtrl,
                            thighCtrl: _thighCtrl,
                          ),
                        ),
                        _StepScroll(
                          child: TrainingStep(
                            daysCtrl: _commitmentDaysCtrl,
                            trainerCtrl: _trainerCtrl,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _FooterButton(
                    label: state.isLastStep ? 'إرسال الاستبيان' : 'التالي',
                    enabled: state.canProceed,
                    onPressed: () => _onNext(context, state),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

final class _StepScroll extends StatelessWidget {
  const _StepScroll({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
      child: child,
    );
  }
}

final class _FooterButton extends StatelessWidget {
  const _FooterButton({
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      elevation: 8,
      shadowColor: AppColors.neutral1000.withValues(alpha: 0.15),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
          child: AppButton(
            label: label,
            onPressed: enabled ? onPressed : null,
          ),
        ),
      ),
    );
  }
}
