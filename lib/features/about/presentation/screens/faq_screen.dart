import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glory_gym/core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/router/app_routes.dart';
import '../cubits/faqs/faqs_cubit.dart';
import '../../../../core/l10n/l10n_extension.dart';

final class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FaqsCubit>()..loadFaqs(),
      child: AppScaffold(
        appBar: AppPrimaryHeader(
          title: context.l10n.faq,
          showBack: true,
          centerTitle: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<FaqsCubit, FaqsState>(
                builder: (context, state) {
                  if (state.status == FaqsStatus.failure && state.faqs.isEmpty) {
                    return _ErrorView(
                      message: state.errorMessage ?? context.l10n.errorTryAgain,
                      onRetry: () => context.read<FaqsCubit>().loadFaqs(),
                    );
                  }

                  final isArabic = ContentUtils.isArabic(context);
                  final itemCount = state.isLoading ? 4 : state.faqs.length;

                  return Skeletonizer(
                    enabled: state.isLoading,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(18),
                      itemCount: itemCount,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        if (state.isLoading) {
                          return _FaqAccordion(
                            question: context.l10n.tempLoadingQuestion,
                            answer: context.l10n.tempLoadingAnswer,
                          );
                        }

                        final faq = state.faqs[index];
                        return _FaqAccordion(
                          question: faq.questionFor(isArabic: isArabic),
                          answer: faq.answerFor(isArabic: isArabic),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            _BottomComplaintsButton(
              onTap: () => context.push(AppRoutes.complaints),
            ),
          ],
        ),
      ),
    );
  }
}

final class _FaqAccordion extends StatefulWidget {
  const _FaqAccordion({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  State<_FaqAccordion> createState() => _FaqAccordionState();
}

final class _FaqAccordionState extends State<_FaqAccordion> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: context.captionBold.copyWith(
                        color: AppColors.neutral900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.neutral700,
                      size: 22,
                    ),
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 10),
                const Divider(height: 1, color: AppColors.neutral200),
                const SizedBox(height: 10),
                Text(
                  widget.answer,
                  style: context.captionRegular.copyWith(
                    color: AppColors.neutral600,
                    height: 1.7,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

final class _BottomComplaintsButton extends StatelessWidget {
  const _BottomComplaintsButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.neutral200)),
      ),
      child: AppButton(
        label: context.l10n.complaintsAndSuggestions,
        onPressed: onTap,
      ),
    );
  }
}

final class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            AppButton(label: context.l10n.retry, onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
