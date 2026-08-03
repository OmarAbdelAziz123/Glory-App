import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glory_gym/core/core.dart';
import 'package:glory_gym/features/auth/presentation/cubits/user_profile/user_profile_cubit.dart';
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
      title: 'تقييم للحصة',
      headline: 'لقد تم تقييم الحصة بنجاح!',
      highlightWord: 'بنجاح',
      description:
          'أهلاً بك في عائلة جلوري جيم! لقد تم تسجيل دخول لحصة (${result.packageNameAr}) '
          'مع الكوتش (${result.instructorName}) متبقي معك ${result.remainingSessions} حصص',
      buttonLabel: 'الرئيسية',
      badgeAsset:
          'assets/images/svgs/success_when_create_anew_password_icon.svg',
      onButtonPressed: () => context.go(AppRoutes.home),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserProfileCubit>().state;
    final locale =
        BookingUtils.localeFromAppLanguage(profile.member?.appLanguage);

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
        appBar: const AppPrimaryHeader(
          title: 'تقييم للحصة',
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
                  state.errorMessage ?? 'حدث خطأ، حاول مرة أخرى',
                  style: context.captionRegular,
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: state.questions.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (_, index) {
                        final question = state.questions[index];
                        final text = locale == 'ar'
                            ? question.questionAr
                            : question.questionEn;
                        return _QuestionCard(
                          question: text,
                          selectedRating: state.answers[question.id],
                          onRatingSelected: (rating) => context
                              .read<ClassEvaluationCubit>()
                              .setAnswer(question.id, rating),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    label: 'إرسال',
                    isLoading: state.status == ClassEvaluationStatus.submitting,
                    onPressed: state.canSubmit ? () => _submit(context) : null,
                  ),
                  const SizedBox(height: 8),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: context.highlightBold,
            textAlign: TextAlign.end,
          ),
          const SizedBox(height: 12),
          for (int rating = 1; rating <= 5; rating++)
            _RatingOption(
              rating: rating,
              isSelected: selectedRating == rating,
              onTap: () => onRatingSelected(rating),
            ),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            _RadioCircle(isSelected: isSelected),
            8.horizontal,
            Text(
              rating.toString(),
              style: context.captionRegular.copyWith(
                color: AppColors.yellow100,
              ),
            ),
            4.horizontal,
            _StarRow(filledCount: rating),
          ],
        ),
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
        for (int i = 1; i <= 5; i++)
          Icon(
            Icons.star_rounded,
            size: 22,
            color: i <= filledCount
                ? AppColors.yellow100
                : AppColors.neutral300,
          ),
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
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.neutral400,
          width: isSelected ? 6 : 1.5,
        ),
      ),
    );
  }
}
