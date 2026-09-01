import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glory_gym/core/core.dart';
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

            final question = state.questions.firstOrNull;
            if (question == null) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: _QuestionCard(
                        question: context.l10n.classSatisfactionQuestion,
                        selectedRating: state.answers[question.id],
                        onRatingSelected: (rating) => context
                            .read<ClassEvaluationCubit>()
                            .setAnswer(question.id, rating),
                      ),
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
          for (int rating = 1; rating <= 5; rating++) ...[
            if (rating > 1) const SizedBox(height: 12),
            _RatingOption(
              rating: rating,
              isSelected: selectedRating == rating,
              onTap: () => onRatingSelected(rating),
            ),
          ],
        ],
      ),
    );
  }
}

final class _RatingOption extends StatelessWidget {
  const _RatingOption({
    required this.rating,
    required this.isSelected,
    required this.onTap,
  });

  final int rating;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _RadioCircle(isSelected: isSelected),
          const SizedBox(width: 8),
          Text(
            rating.toString(),
            style: context.subtitleMedium.copyWith(
              fontSize: 14,
              color: AppColors.yellow100,
            ),
          ),
          const SizedBox(width: 4),
          _StarRow(filledCount: rating),
        ],
      ),
    );
  }
}

final class _StarRow extends StatelessWidget {
  const _StarRow({required this.filledCount});

  final int filledCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 1; i <= 5; i++) ...[
          if (i > 1) const SizedBox(width: 2),
          Icon(
            Icons.star_rounded,
            size: 16,
            color: i <= filledCount
                ? AppColors.yellow100
                : AppColors.neutral300,
          ),
        ],
      ],
    );
  }
}

final class _RadioCircle extends StatelessWidget {
  const _RadioCircle({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.neutral400,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),
            )
          : null,
    );
  }
}
