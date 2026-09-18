import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/onboarding_navigation.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../subscription_questionnaire/presentation/widgets/questionnaire_header.dart';
import '../../domain/entities/onboarding_prefill_entity.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../../domain/entities/onboarding_question_entity.dart';
import '../cubits/dynamic_onboarding/dynamic_onboarding_cubit.dart';
import '../widgets/dynamic_onboarding_question_field.dart';

final class DynamicOnboardingScreen extends StatelessWidget {
  const DynamicOnboardingScreen({super.key, this.prefill});

  final OnboardingPrefillEntity? prefill;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DynamicOnboardingCubit(sl<OnboardingRepository>())
        ..load(prefill: prefill),
      child: const _DynamicOnboardingView(),
    );
  }
}

final class _DynamicOnboardingView extends StatefulWidget {
  const _DynamicOnboardingView();

  @override
  State<_DynamicOnboardingView> createState() => _DynamicOnboardingViewState();
}

final class _DynamicOnboardingViewState extends State<_DynamicOnboardingView> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onNext(BuildContext context, DynamicOnboardingState state) async {
    final cubit = context.read<DynamicOnboardingCubit>();
    if (!state.canProceed || state.isSubmitting || state.isUploading) return;

    if (state.isLastStep) {
      final success = await cubit.submit();
      if (!context.mounted) return;

      if (success) {
        await markOnboardingCompletedLocally();
        if (!context.mounted) return;
        _showSuccess(context);
      } else {
        final error = cubit.state.errorMessage;
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
        }
      }
      return;
    }

    cubit.nextStep();
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _onBack(BuildContext context, DynamicOnboardingState state) {
    if (state.isSubmitting || state.isUploading) return;

    if (state.step > 0) {
      context.read<DynamicOnboardingCubit>().previousStep();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _showSuccess(BuildContext context) {
    AppSuccessSheet.show(
      context,
      title: context.l10n.personalData,
      headline: context.l10n.dataSavedSuccess,
      highlightWord: context.l10n.successfully,
      description: context.l10n.onboardingTeamReviewMessage,
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
    return BlocConsumer<DynamicOnboardingCubit, DynamicOnboardingState>(
      listenWhen: (previous, current) =>
          current.status == DynamicOnboardingStatus.alreadyCompleted ||
          (previous.totalSteps != current.totalSteps &&
              current.totalSteps > 0 &&
              _pageController.hasClients),
      listener: (context, state) async {
        if (state.status == DynamicOnboardingStatus.alreadyCompleted) {
          await markOnboardingCompletedLocally();
          if (!context.mounted) return;
          context.go(AppRoutes.home);
          return;
        }

        final maxIndex = state.totalSteps - 1;
        final target = state.step.clamp(0, maxIndex);
        if (_pageController.page?.round() != target) {
          _pageController.jumpToPage(target);
        }
      },
      builder: (context, state) {
        if (state.status == DynamicOnboardingStatus.loading) {
          return AppScaffold(
            backgroundColor: AppColors.neutral100,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == DynamicOnboardingStatus.failure &&
            state.questions.isEmpty) {
          return AppScaffold(
            backgroundColor: AppColors.neutral100,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.errorTryAgain,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      label: context.l10n.retry,
                      onPressed: () => context
                          .read<DynamicOnboardingCubit>()
                          .load(),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state.visibleQuestions.isEmpty) {
          return AppScaffold(
            backgroundColor: AppColors.neutral100,
            body: Center(child: Text(context.l10n.noData)),
          );
        }

        final locale = context.l10n.localeName;

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
              totalSteps: state.totalSteps,
              title: context.l10n.personalData,
              onBack: state.step == 0 ? null : () => _onBack(context, state),
            ),
            body: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.totalSteps,
                    itemBuilder: (context, index) {
                      final question = state.visibleQuestions[index];
                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
                        child: DynamicOnboardingQuestionField(
                          question: question,
                          locale: locale,
                          value: state.answers[question.id],
                          isUploading:
                              state.uploadingQuestionId == question.id,
                          onChanged: (value) => context
                              .read<DynamicOnboardingCubit>()
                              .setAnswer(question.id, value),
                          onUploadPhoto: question.type ==
                                  OnboardingQuestionType.photo
                              ? (path) => context
                                  .read<DynamicOnboardingCubit>()
                                  .uploadPhoto(question.id, path)
                              : null,
                          onRemovePhoto: question.type ==
                                  OnboardingQuestionType.photo
                              ? (url) => context
                                  .read<DynamicOnboardingCubit>()
                                  .removePhoto(question.id, url)
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                _FooterButton(
                  label: state.isLastStep
                      ? context.l10n.submitData
                      : context.l10n.next,
                  enabled: state.canProceed &&
                      !state.isSubmitting &&
                      !state.isUploading,
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
