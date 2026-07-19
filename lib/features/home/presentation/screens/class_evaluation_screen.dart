import 'package:flutter/material.dart';
import 'package:glory_gym/core/core.dart';
import 'package:go_router/go_router.dart';

// ── Screen ────────────────────────────────────────────────────────────────────

final class ClassEvaluationScreen extends StatefulWidget {
  const ClassEvaluationScreen({super.key});

  @override
  State<ClassEvaluationScreen> createState() => _ClassEvaluationScreenState();
}

final class _ClassEvaluationScreenState extends State<ClassEvaluationScreen> {
  static const _questions = <String>['السوال', 'السوال', 'السوال'];

  final Map<int, int> _answers = {};

  bool get _canSubmit => _answers.length == _questions.length;

  void _submit() {
    AppSuccessSheet.show(
      context,
      title: 'تقييم للحصة',
      headline: 'لقد تم تقييم الحصة بنجاح!',
      highlightWord: 'بنجاح',
      description:
          'أهلاً بك في عائلة جلوري جيم! لقد تم تسجيل دخول لحصة ( اسم الباكدج )'
          ' مع الكوتش ( اسم المدرب ) متبقي معك من 3 حصص',
      buttonLabel: 'الرئيسية',
      badgeAsset:
          'assets/images/svgs/success_when_create_anew_password_icon.svg',
      onButtonPressed: () => context.go(AppRoutes.home),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const AppPrimaryHeader(
        title: 'تقييم للحصة',
        showBack: true,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: _questions.length,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (_, index) => _QuestionCard(
                  question: _questions[index],
                  selectedRating: _answers[index],
                  onRatingSelected: (rating) {
                    setState(() => _answers[index] = rating);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppButton(label: 'إرسال', onPressed: _canSubmit ? _submit : null),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── Private widgets ───────────────────────────────────────────────────────────

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
