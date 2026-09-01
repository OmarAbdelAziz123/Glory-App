import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../onboarding/domain/entities/onboarding_prefill_entity.dart';
import '../../../onboarding/domain/repositories/onboarding_repository.dart';
import '../../../subscription_questionnaire/presentation/cubits/questionnaire/questionnaire_cubit.dart';
import '../../../subscription_questionnaire/presentation/widgets/questionnaire_header.dart';
import '../../../subscription_questionnaire/presentation/widgets/steps/activity_step.dart';
import '../../../subscription_questionnaire/presentation/widgets/steps/goals_step.dart';
import '../../../subscription_questionnaire/presentation/widgets/steps/lifestyle_step.dart';
import '../../../subscription_questionnaire/presentation/widgets/steps/measurements_step.dart';
import '../../../subscription_questionnaire/presentation/widgets/steps/medical_history_step.dart';
import '../../../subscription_questionnaire/presentation/widgets/steps/nutrition_step.dart';
import '../../../subscription_questionnaire/presentation/widgets/steps/personal_data_step.dart';
import '../../../subscription_questionnaire/presentation/widgets/steps/training_step.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/utils/onboarding_navigation.dart';

final class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key, this.prefill});

  final OnboardingPrefillEntity? prefill;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuestionnaireCubit()..applyPrefill(prefill),
      child: const _OnboardingView(),
    );
  }
}

final class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

final class _OnboardingViewState extends State<_OnboardingView> {
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
    }
  }

  Future<void> _onNext(BuildContext context, QuestionnaireState state) async {
    final cubit = context.read<QuestionnaireCubit>();
    if (!state.canProceed || state.isSubmitting) return;

    _syncPhoneCountryCode(cubit);

    if (state.isLastStep) {
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

    cubit.nextStep();
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _showSuccess(BuildContext context) {
    AppSuccessSheet.show(
      context,
      title: context.l10n.personalData,
      headline: context.l10n.dataSavedSuccess,
      highlightWord: context.l10n.successfully,
      description:
          context.l10n.onboardingTeamReviewMessage,
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
    return BlocBuilder<QuestionnaireCubit, QuestionnaireState>(
        builder: (context, state) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) _onBack(context, state);
            },
            child: AppScaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: AppColors.neutral100,
              appBar: QuestionnaireHeader(
                currentStep: state.step,
                totalSteps: QuestionnaireState.totalSteps,
                title: context.l10n.personalData,
                onBack: state.step > 0 ? () => _onBack(context, state) : null,
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
                            phoneFieldKey: _phoneFieldKey,
                          ),
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
                        _StepScroll(
                          child: GoalsStep(otherGoalCtrl: _otherGoalCtrl),
                        ),
                      ],
                    ),
                  ),
                  _FooterButton(
                    label: state.isLastStep ? context.l10n.submitData : context.l10n.next,
                    enabled: state.canProceed && !state.isSubmitting,
                    isLoading: state.isSubmitting,
                    onPressed: () => _onNext(context, state),
                  ),
                ],
              ),
            ),
          );
        },
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
