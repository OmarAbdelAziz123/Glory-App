import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glory_gym/core/core.dart';
import 'package:glory_gym/features/home/presentation/widgets/group_class_card.dart';
import 'package:glory_gym/features/workouts/presentation/cubits/workout_detail/workout_detail_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

final class WorkoutDetailScreen extends StatelessWidget {
  const WorkoutDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WorkoutDetailCubit>(param1: id)..loadDetail(),
      child: _WorkoutDetailView(assignmentId: id),
    );
  }
}

final class _WorkoutDetailView extends StatelessWidget {
  const _WorkoutDetailView({required this.assignmentId});

  final String assignmentId;

  Future<void> _openAddWeight(BuildContext context) async {
    final added = await context.push<bool>(
      '/workouts/$assignmentId/add-weight',
    );

    if (added == true && context.mounted) {
      await context.read<WorkoutDetailCubit>().loadDetail();
    }
  }

  Future<void> _openVideo(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.l10n.localeName;

    return BlocListener<WorkoutDetailCubit, WorkoutDetailState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null,
      listener: (context, state) {
        final message = state.errorMessage;
        if (message == null) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
      child: AppScaffold(
        backgroundColor: AppColors.neutral100,
        appBar: AppPrimaryHeader(
          title: context.l10n.workoutDetails,
          showBack: true,
          centerTitle: true,
        ),
        body: BlocBuilder<WorkoutDetailCubit, WorkoutDetailState>(
          builder: (context, state) {
            if (state.isLoading && state.detail == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final detail = state.detail;
            if (detail == null) {
              return Center(
                child: Text(
                  state.errorMessage ?? context.l10n.errorTryAgain,
                  style: context.captionRegular,
                ),
              );
            }

            final cardStatus = WorkoutUtils.cardStatus(detail.status);
            final workoutType =
                WorkoutUtils.typeLabel(context.l10n, detail.workoutType);
            final fallback = context.l10n.notAvailable;
            final suggestedWeight = WorkoutUtils.displayOrFallback(
              WorkoutUtils.weightLabel(context.l10n, detail.suggestedWeight),
              fallback,
            );
            final isSubmittingWeight =
                state.status == WorkoutDetailStatus.submittingWeight;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppEntrance(
                    delay: const Duration(milliseconds: 40),
                    offset: const Offset(0, 0.05),
                    child: _SummaryCard(
                      name: WorkoutUtils.workoutNameFromDetail(
                        detail,
                        locale: locale,
                      ),
                      status: cardStatus,
                      setLabel: WorkoutUtils.displayOrFallback(
                        WorkoutUtils.durationLabel(
                          context.l10n,
                          detail.durationDays,
                        ),
                        fallback,
                      ),
                      repetitionLabel: WorkoutUtils.displayOrFallback(
                        workoutType,
                        fallback,
                      ),
                      startDate: WorkoutUtils.displayOrFallback(
                        WorkoutUtils.formatDate(context.l10n, detail.startDate),
                        fallback,
                      ),
                      endDate: WorkoutUtils.displayOrFallback(
                        WorkoutUtils.formatDate(context.l10n, detail.endDate),
                        fallback,
                      ),
                      remainingDays: WorkoutUtils.displayOrFallback(
                        WorkoutUtils.remainingDaysLabel(
                          context.l10n,
                          detail.remainingDays,
                        ),
                        fallback,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppEntrance(
                    delay: const Duration(milliseconds: 120),
                    child: AppDividerLabel(
                      label: context.l10n.generalWorkoutInstructions,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...detail.instructions.asMap().entries.map(
                    (entry) {
                      final instruction = entry.value;
                      final instructionText = WorkoutUtils.instructionLabel(
                        instruction,
                        locale: locale,
                      );

                      return AppEntrance(
                        key: ValueKey('phase-${instruction.stepNumber}'),
                        delay: Duration(
                          milliseconds: 160 + (entry.key.clamp(0, 5) * 80),
                        ),
                        offset: const Offset(0, 0.06),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _InstructionCard(
                            phaseLabel: WorkoutUtils.phaseLabel(
                              context.l10n,
                              instruction.stepNumber,
                            ),
                            instructionText: instructionText,
                            suggestedWeight: suggestedWeight,
                            thumbnailUrl: instruction.videos.isNotEmpty
                                ? instruction.videos.first.thumbnailUrl
                                : null,
                            onPlay: instruction.videos.isNotEmpty
                                ? () => _openVideo(
                                      instruction.videos.first.videoUrl,
                                    )
                                : null,
                            showAddWeight: detail.canAddWeight,
                            isAddWeightLoading: isSubmittingWeight,
                            onAddWeight: () => _openAddWeight(context),
                          ),
                        ),
                      );
                    },
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

final class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.name,
    required this.status,
    required this.setLabel,
    required this.repetitionLabel,
    required this.startDate,
    required this.endDate,
    required this.remainingDays,
  });

  final String name;
  final GroupClassStatus status;
  final String setLabel;
  final String repetitionLabel;
  final String startDate;
  final String endDate;
  final String remainingDays;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        children: [
          _TitleRow(name: name, status: status),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.neutral200),
          const SizedBox(height: 12),
          _InfoGridRow(
            columns: [
              (label: context.l10n.workoutSet, value: setLabel),
              (label: context.l10n.workoutRepetition, value: repetitionLabel),
              (label: context.l10n.startDate, value: startDate),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.neutral200),
          const SizedBox(height: 12),
          _InfoGridRow(
            columns: [
              (label: context.l10n.endDate, value: endDate),
              (label: context.l10n.remainingDaysCount, value: remainingDays),
            ],
          ),
        ],
      ),
    );
  }
}

final class _InstructionCard extends StatelessWidget {
  const _InstructionCard({
    required this.phaseLabel,
    required this.instructionText,
    required this.suggestedWeight,
    this.thumbnailUrl,
    this.onPlay,
    required this.showAddWeight,
    required this.isAddWeightLoading,
    required this.onAddWeight,
  });

  final String phaseLabel;
  final String instructionText;
  final String suggestedWeight;
  final String? thumbnailUrl;
  final VoidCallback? onPlay;
  final bool showAddWeight;
  final bool isAddWeightLoading;
  final VoidCallback onAddWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _InfoValueColumn(
                    label: phaseLabel,
                    value: instructionText,
                  ),
                ),
                const VerticalDivider(width: 1, color: AppColors.neutral200),
                Expanded(
                  child: _InfoValueColumn(
                    label: context.l10n.suggestedWeight,
                    value: suggestedWeight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onPlay,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: double.infinity,
                height: 160,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty)
                      Image.network(
                        thumbnailUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Image.asset(
                          'assets/images/pngs/classes_image.png',
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Image.asset(
                        'assets/images/pngs/classes_image.png',
                        fit: BoxFit.cover,
                      ),
                    if (onPlay != null)
                      Center(
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.85),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            size: 28,
                            color: AppColors.neutral900,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (showAddWeight) ...[
            const SizedBox(height: 12),
            AppButton(
              label: context.l10n.addWeight,
              height: 48,
              variant: AppButtonVariant.outlined,
              onPressed: isAddWeightLoading ? null : onAddWeight,
              isLoading: isAddWeightLoading,
            ),
          ],
        ],
      ),
    );
  }
}

final class _TitleRow extends StatelessWidget {
  const _TitleRow({required this.name, required this.status});

  final String name;
  final GroupClassStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      GroupClassStatus.ongoing => (
          context.l10n.workoutInProgress,
          AppColors.primary,
        ),
      GroupClassStatus.upcoming => (
          context.l10n.upcomingWorkout,
          AppColors.red100,
        ),
      GroupClassStatus.completed => (
          context.l10n.completedWorkout,
          AppColors.green200,
        ),
    };

    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: context.highlightBold.copyWith(color: AppColors.neutral900),
          ),
        ),
        const SizedBox(width: 12),
        _StatusChip(label: label, color: color),
      ],
    );
  }
}

final class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: context.footnoteRegular.copyWith(color: color),
      ),
    );
  }
}

final class _InfoGridRow extends StatelessWidget {
  const _InfoGridRow({required this.columns});

  final List<({String label, String value})> columns;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          for (int i = 0; i < columns.length; i++) ...[
            if (i > 0)
              const VerticalDivider(width: 1, color: AppColors.neutral200),
            Expanded(
              child: _InfoValueColumn(
                label: columns[i].label,
                value: columns[i].value,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

final class _InfoValueColumn extends StatelessWidget {
  const _InfoValueColumn({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: context.footnoteRegular.copyWith(color: AppColors.neutral400),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: context.subtitleMedium.copyWith(color: AppColors.neutral900),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
