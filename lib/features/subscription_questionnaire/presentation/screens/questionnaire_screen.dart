import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/models/questionnaire_args.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../onboarding/domain/repositories/onboarding_repository.dart';
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
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/utils/onboarding_navigation.dart';

final class QuestionnaireScreen extends StatelessWidget {
  const QuestionnaireScreen({super.key, this.args});

  final QuestionnaireScreenArgs? args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuestionnaireCubit()..applyPrefill(args?.prefill),
      child: _QuestionnaireView(completeToHome: args?.completeToHome ?? false),
    );
  }
}

final class _QuestionnaireView extends StatefulWidget {
  const _QuestionnaireView({required this.completeToHome});

  final bool completeToHome;

  @override
  State<_QuestionnaireView> createState() => _QuestionnaireViewState();
}

final class _QuestionnaireViewState extends State<_QuestionnaireView> {
  final _pageController = PageController();
  final _phoneFieldKey = GlobalKey<AppPhoneFieldState>();

  final _fullNameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _professionCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _otherGoalCtrl = TextEditingController();
  final _injuriesCtrl = TextEditingController();
  final _surgeryCtrl = TextEditingController();
  final _exerciseDaysCtrl = TextEditingController();
  final _exerciseTypesCtrl = TextEditingController();
  final _exerciseDurationCtrl = TextEditingController();
  final _mealsCtrl = TextEditingController();
  final _waterCtrl = TextEditingController();
  final _sleepCtrl = TextEditingController();
  final _bodyFatCtrl = TextEditingController();
  final _waistCtrl = TextEditingController();
  final _chestCtrl = TextEditingController();
  final _armCtrl = TextEditingController();
  final _thighCtrl = TextEditingController();
  final _commitmentDaysCtrl = TextEditingController();
  final _trainerCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncPrefillToControllers());
  }

  void _syncPrefillToControllers() {
    final state = context.read<QuestionnaireCubit>().state;
    _fullNameCtrl.text = state.fullName;
    _phoneCtrl.text = state.phone;
    _phoneFieldKey.currentState?.setDialCode(state.phoneCountryCode);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fullNameCtrl.dispose();
    _ageCtrl.dispose();
    _professionCtrl.dispose();
    _phoneCtrl.dispose();
    _otherGoalCtrl.dispose();
    _injuriesCtrl.dispose();
    _surgeryCtrl.dispose();
    _exerciseDaysCtrl.dispose();
    _exerciseTypesCtrl.dispose();
    _exerciseDurationCtrl.dispose();
    _mealsCtrl.dispose();
    _waterCtrl.dispose();
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

  void _syncPhoneCountryCode(QuestionnaireCubit cubit) {
    final code = _phoneFieldKey.currentState?.countryCode.dialCode;
    if (code != null) {
      cubit.updatePhoneCountryCode(code);
    }
  }

  void _onBack(BuildContext context, QuestionnaireState state) {
    if (state.isSubmitting) return;

    if (state.step > 0) {
      context.read<QuestionnaireCubit>().previousStep();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
      return;
    }

    if (!widget.completeToHome) {
      Navigator.of(context).maybePop();
    }
  }

  Future<void> _onNext(BuildContext context, QuestionnaireState state) async {
    final cubit = context.read<QuestionnaireCubit>();
    if (!state.canProceed || state.isSubmitting) return;

    _syncPhoneCountryCode(cubit);

    if (state.isLastStep) {
      if (widget.completeToHome) {
        final success = await cubit.submitOnboarding(sl<OnboardingRepository>());
        if (!context.mounted) return;

        if (success) {
          await markOnboardingCompletedLocally();
          if (!context.mounted) return;
          _showSuccess(context);
          return;
        }

        final error = cubit.state.errorMessage;
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
        }
        return;
      }

      cubit.markSubmittedLocally();
      return;
    }

    cubit.nextStep();
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _showSuccess(BuildContext context) {
    AppSuccessSheet.show(
      context,
      title: widget.completeToHome ? context.l10n.personalData : context.l10n.subscriptionQuestionnaire,
      headline: widget.completeToHome
          ? context.l10n.dataSavedSuccess
          : context.l10n.questionnaireSent,
      highlightWord: widget.completeToHome ? context.l10n.successfully : context.l10n.questionnaireSent,
      description: widget.completeToHome
          ? context.l10n.onboardingTeamReviewMessage
          : context.l10n.onboardingCoachReviewMessage,
      buttonLabel: context.l10n.home,
      badgeAsset: 'assets/images/svgs/questionnaire_success_badge.svg',
      onButtonPressed: () {
        Navigator.of(context).pop();
        context.go(AppRoutes.home);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuestionnaireCubit, QuestionnaireState>(
      listenWhen: (prev, curr) =>
          !widget.completeToHome &&
          prev.status != curr.status &&
          curr.status == QuestionnaireStatus.submitted,
      listener: (context, state) => _showSuccess(context),
      child: BlocBuilder<QuestionnaireCubit, QuestionnaireState>(
        builder: (context, state) {
          return PopScope(
            canPop: !widget.completeToHome && state.step == 0,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) _onBack(context, state);
            },
            child: AppScaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: AppColors.neutral100,
              appBar: QuestionnaireHeader(
                currentStep: state.step,
                totalSteps: QuestionnaireState.totalSteps,
                onBack: widget.completeToHome && state.step == 0
                    ? null
                    : () => _onBack(context, state),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: Transform.translate(
                      offset: const Offset(0, -12),
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
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
                            phoneFieldKey: _phoneFieldKey,
                          ),
                        ),
                        _StepScroll(
                          child: GoalsStep(otherGoalCtrl: _otherGoalCtrl),
                        ),
                        _StepScroll(
                          child: MedicalHistoryStep(
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
                          ),
                        ),
                        _StepScroll(child: LifestyleStep(sleepCtrl: _sleepCtrl)),
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
                      ),
                    ),
                  ),
                  _FooterButton(
                    label: state.isLastStep
                        ? (widget.completeToHome ? context.l10n.submitData : context.l10n.submitQuestionnaire)
                        : context.l10n.next,
                    enabled: state.canProceed && !state.isSubmitting,
                    isLoading: state.isSubmitting,
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
    this.isLoading = false,
  });

  final String label;
  final bool enabled;
  final VoidCallback onPressed;
  final bool isLoading;

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
            isLoading: isLoading,
            onPressed: enabled ? onPressed : null,
          ),
        ),
      ),
    );
  }
}
