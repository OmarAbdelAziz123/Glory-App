import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glory_gym/core/core.dart';
import 'package:glory_gym/features/bookings/presentation/bookings_refresh_notifier.dart';
import 'package:glory_gym/features/bookings/presentation/cubits/class_evaluation/class_evaluation_cubit.dart';
import 'package:go_router/go_router.dart';

final class ClassEvaluationScreen extends StatelessWidget {
  const ClassEvaluationScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ClassEvaluationCubit>(param1: bookingId)..loadQuestions(),
      child: _ClassEvaluationView(bookingId: bookingId),
    );
  }
}

final class _ClassEvaluationView extends StatelessWidget {
  const _ClassEvaluationView({required this.bookingId});

  final String bookingId;

  Future<void> _submit(BuildContext context) async {
    final success = await context.read<ClassEvaluationCubit>().submit();
    if (!context.mounted || !success) return;

    BookingsRefreshNotifier.request();

    final result = context.read<ClassEvaluationCubit>().state.result;
    if (result == null) return;

    AppSuccessSheet.show(
      context,
      title: context.l10n.evaluateClass,
      headline: context.l10n.classEvaluatedSuccess,
      highlightWord: context.l10n.successfully,
      description:
          '${context.l10n.checkinClassWelcomePrefix(result.packageNameAr)}'
          '${context.l10n.checkinClassWelcomeSuffix(result.instructorName, '${result.remainingSessions}')}',
      buttonLabel: context.l10n.home,
      badgeAsset:
          'assets/images/svgs/success_when_create_anew_password_icon.svg',
      onButtonPressed: () => context.go(AppRoutes.home),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClassEvaluationCubit, ClassEvaluationState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null &&
          current.status == ClassEvaluationStatus.failure,
      listener: (context, state) {
        final message = state.errorMessage;
        if (message == null) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
      child: AppScaffold(
        appBar: AppPrimaryHeader(
          title: context.l10n.evaluateClass,
          showBack: true,
          centerTitle: false,
        ),
        body: BlocBuilder<ClassEvaluationCubit, ClassEvaluationState>(
          builder: (context, state) {
            if (state.status == ClassEvaluationStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == ClassEvaluationStatus.failure &&
                state.questions.isEmpty) {
              return Center(
                child: Text(
                  state.errorMessage ?? context.l10n.errorTryAgain,
                  style: context.captionRegular,
                ),
              );
            }

            if (state.questions.isEmpty) {
              return Center(
                child: Text(
                  context.l10n.noData,
                  style: context.captionRegular.copyWith(
                    color: AppColors.neutral500,
                  ),
                ),
              );
            }

            final locale = context.l10n.localeName;

            return Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: state.questions.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final question = state.questions[index];
                        return _QuestionCard(
                          question: BookingUtils.assessmentQuestionLabel(
                            question,
                            locale: locale,
                          ),
                          selectedRating: state.answers[question.id],
                          onRatingSelected: (rating) => context
                              .read<ClassEvaluationCubit>()
                              .setAnswer(question.id, rating),
                        );
                      },
                    ),
                  ),
                  AppButton(
                    label: context.l10n.submit,
                    isLoading: state.status == ClassEvaluationStatus.submitting,
                    onPressed: state.canSubmit ? () => _submit(context) : null,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

final class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    required this.selectedRating,
    required this.onRatingSelected,
  });

  final String question;
  final int? selectedRating;
  final ValueChanged<int> onRatingSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            question,
            style: context.subtitleMedium,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 16),
          _InteractiveStarRating(
            rating: selectedRating,
            onRatingChanged: onRatingSelected,
          ),
        ],
      ),
    );
  }
}

final class _InteractiveStarRating extends StatelessWidget {
  const _InteractiveStarRating({
    required this.rating,
    required this.onRatingChanged,
  });

  final int? rating;
  final ValueChanged<int> onRatingChanged;

  static const _starCount = 5;
  static const _starSize = 36.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int star = 1; star <= _starCount; star++) ...[
          if (star > 1) const SizedBox(width: 8),
          GestureDetector(
            onTap: () => onRatingChanged(star),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.star_rounded,
                size: _starSize,
                color: rating != null && star <= rating!
                    ? AppColors.yellow100
                    : AppColors.neutral300,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
