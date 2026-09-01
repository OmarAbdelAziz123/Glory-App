import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/l10n/l10n_extension.dart';

// ── Model ─────────────────────────────────────────────────────────────────────

enum GroupClassStatus { ongoing, upcoming, completed }

final class GroupClassItem {
  const GroupClassItem({
    required this.className,
    required this.imageAsset,
    required this.classType,
    required this.time,
    this.startDate,
    this.issuedBy,
    this.thumbnailUrl,
    this.status = GroupClassStatus.upcoming,
  });

  final String className;
  final String imageAsset;
  final String classType;
  final String time;
  final String? startDate;
  final String? issuedBy;
  final String? thumbnailUrl;
  final GroupClassStatus status;
}

// ── Public widget ─────────────────────────────────────────────────────────────

final class GroupClassCard extends StatelessWidget {
  const GroupClassCard({
    super.key,
    required this.item,
    this.onEvaluate,
    this.showPlayButton = true,
    this.useWorkoutMetricLabels = false,
  });

  final GroupClassItem item;
  final VoidCallback? onEvaluate;
  final bool showPlayButton;
  final bool useWorkoutMetricLabels;

  static const _cardRadius = 8.0;
  static const _imageHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(_cardRadius),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ClassImageHeader(
            imageAsset: item.imageAsset,
            thumbnailUrl: item.thumbnailUrl,
            showPlayButton: showPlayButton,
            imageHeight: _imageHeight,
          ),
          const SizedBox(height: 16),
          _TitleRow(className: item.className, status: item.status),
          const SizedBox(height: 16),
          _DetailsRow(
            time: item.time,
            classType: item.classType,
            startDate: item.startDate,
            issuedBy: item.issuedBy,
            useWorkoutMetricLabels: useWorkoutMetricLabels,
          ),
          if (onEvaluate != null) ...[
            const SizedBox(height: 12),
            AppButton(
              label: context.l10n.classEvaluation,
              height: 48,
              onPressed: onEvaluate,
            ),
          ],
        ],
      ),
    );
  }
}

// ── Private widgets ───────────────────────────────────────────────────────────

final class _ClassImageHeader extends StatelessWidget {
  const _ClassImageHeader({
    required this.imageAsset,
    required this.imageHeight,
    this.thumbnailUrl,
    this.showPlayButton = true,
  });

  final String imageAsset;
  final double imageHeight;
  final String? thumbnailUrl;
  final bool showPlayButton;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: double.infinity,
        height: imageHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty)
              Image.network(
                thumbnailUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    Image.asset(imageAsset, fit: BoxFit.cover),
              )
            else
              Image.asset(imageAsset, fit: BoxFit.cover),
            if (showPlayButton)
              Center(
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 24,
                  color: AppColors.white.withValues(alpha: 0.95),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final class _TitleRow extends StatelessWidget {
  const _TitleRow({required this.className, required this.status});

  final String className;
  final GroupClassStatus status;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            className,
            style: context.contentSemibold,
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(width: 16),
        _StatusChip(status: status),
      ],
    );
  }
}

final class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final GroupClassStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color, background) = switch (status) {
      GroupClassStatus.ongoing => (
          context.l10n.workoutInProgress,
          AppColors.yellow100,
          AppColors.yellow10,
        ),
      GroupClassStatus.upcoming => (
          context.l10n.upcomingWorkout,
          AppColors.red100,
          AppColors.red10,
        ),
      GroupClassStatus.completed => (
          context.l10n.completedWorkout,
          AppColors.green200,
          const Color(0x1A1FC16B),
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: context.subtitleMedium.copyWith(
          color: color,
          fontSize: 10,
          height: 1,
        ),
      ),
    );
  }
}

final class _DetailsRow extends StatelessWidget {
  const _DetailsRow({
    required this.time,
    required this.classType,
    this.startDate,
    this.issuedBy,
    this.useWorkoutMetricLabels = false,
  });

  final String time;
  final String classType;
  final String? startDate;
  final String? issuedBy;
  final bool useWorkoutMetricLabels;

  @override
  Widget build(BuildContext context) {
    final thirdValue = issuedBy ?? startDate;

    return Container(
      padding: const EdgeInsets.only(top: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.neutral200)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _DetailColumn(
                label: useWorkoutMetricLabels
                    ? context.l10n.workoutSet
                    : context.l10n.time,
                value: time,
              ),
            ),
            const SizedBox(width: 14),
            const VerticalDivider(width: 1, color: AppColors.neutral200),
            const SizedBox(width: 14),
            Expanded(
              child: _DetailColumn(
                label: useWorkoutMetricLabels
                    ? context.l10n.workoutRepetition
                    : context.l10n.workoutType,
                value: classType,
              ),
            ),
            if (thirdValue != null) ...[
              const SizedBox(width: 14),
              const VerticalDivider(width: 1, color: AppColors.neutral200),
              const SizedBox(width: 14),
              Expanded(
                child: _DetailColumn(
                  label: issuedBy != null
                      ? context.l10n.issuedBy
                      : context.l10n.startDate,
                  value: thirdValue,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

final class _DetailColumn extends StatelessWidget {
  const _DetailColumn({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: context.captionRegular.copyWith(color: AppColors.neutral400),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: context.contentSemibold,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}
