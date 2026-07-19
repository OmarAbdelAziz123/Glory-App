import 'package:flutter/material.dart';
import 'package:glory_gym/core/core.dart';
import 'package:go_router/go_router.dart';

import '../../../home/presentation/widgets/group_class_card.dart';

// ── Private models ────────────────────────────────────────────────────────────

final class _WorkoutPhase {
  const _WorkoutPhase({
    required this.phaseLabel,
    required this.type,
    required this.imageAsset,
    required this.suggestedWeight,
    this.actualWeight,
    this.showPlayButton = false,
  });

  final String phaseLabel;
  final String type;
  final String imageAsset;
  final String suggestedWeight;
  final String? actualWeight;
  final bool showPlayButton;
}

final class _WorkoutDetailData {
  const _WorkoutDetailData({
    required this.name,
    required this.status,
    required this.time,
    required this.type,
    required this.startDate,
    this.endDate,
    this.createdDate,
    this.daysRemaining,
    required this.phases,
  });

  final String name;
  final GroupClassStatus status;
  final String time;
  final String type;
  final String startDate;
  final String? endDate;
  final String? createdDate;
  final String? daysRemaining;
  final List<_WorkoutPhase> phases;
}

// ── Screen ────────────────────────────────────────────────────────────────────

final class WorkoutDetailScreen extends StatelessWidget {
  const WorkoutDetailScreen({super.key, required this.id});

  final String id;

  static final _demos = <String, _WorkoutDetailData>{
    '0': _WorkoutDetailData(
      name: 'اسم التمرين',
      status: GroupClassStatus.completed,
      time: '40 يوم',
      type: 'كارديو',
      startDate: '١ مايو ٢٠٢٦',
      endDate: '١٠ يونيو ٢٠٢٦',
      phases: [
        const _WorkoutPhase(
          phaseLabel: 'المرحلة الاولة',
          type: 'كارديو',
          imageAsset: 'assets/images/pngs/classes_image.png',
          suggestedWeight: '10 كيلو',
        ),
        const _WorkoutPhase(
          phaseLabel: 'المرحلة الثانية',
          type: 'كارديو',
          imageAsset: 'assets/images/pngs/classes_image.png',
          suggestedWeight: '10 كيلو',
        ),
      ],
    ),
    '1': _WorkoutDetailData(
      name: 'اسم التمرين',
      status: GroupClassStatus.ongoing,
      time: '40 يوم',
      type: 'كارديو',
      startDate: '١ مايو ٢٠٢٦',
      createdDate: '١٠ يونيو ٢٠٢٦',
      daysRemaining: '22 يوم',
      phases: [
        _WorkoutPhase(
          phaseLabel: 'المرحلة الاولة',
          type: 'كارديو',
          imageAsset: 'assets/images/pngs/classes_image.png',
          suggestedWeight: '10 كيلو',
          actualWeight: '20 كيلو',
        ),
        const _WorkoutPhase(
          phaseLabel: 'المرحلة الثانية',
          type: 'كارديو',
          imageAsset: 'assets/images/pngs/classes_image.png',
          suggestedWeight: '10 كيلو',
          actualWeight: '40 يوم',
          showPlayButton: true,
        ),
      ],
    ),
  };

  _WorkoutDetailData get _data => _demos[id] ?? _demos['1']!;

  @override
  Widget build(BuildContext context) {
    final detail = _data;
    return AppScaffold(
      appBar: const AppPrimaryHeader(
        title: 'تفاصيل التمرين',
        showBack: true,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HeaderCard(detail: detail),
            if (detail.status == GroupClassStatus.completed) ...[
              const SizedBox(height: 12),
              AppButton(
                label: 'تقييم الحصة',
                height: 48,
                onPressed: () => context.push(AppRoutes.classEvaluation),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              'تعليمات التمرين العامة',
              textAlign: TextAlign.end,
              style: context.highlightBold.copyWith(
                color: AppColors.neutral900,
              ),
            ),
            const SizedBox(height: 12),
            ...detail.phases.map(
              (phase) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _PhaseCard(
                  phase: phase,
                  onAddWeight: detail.status == GroupClassStatus.ongoing
                      ? () => context.push(AppRoutes.addWeight)
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private widgets ───────────────────────────────────────────────────────────

final class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.detail});

  final _WorkoutDetailData detail;

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
          _TitleRow(name: detail.name, status: detail.status),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.neutral200),
          const SizedBox(height: 12),
          _ThreeColumnRow(
            col1: (label: 'الوقت', value: detail.time),
            col2: (label: 'نوع التمرين', value: detail.type),
            col3: (label: 'تاريخ البداية', value: detail.startDate),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.neutral200),
          const SizedBox(height: 12),
          _StatusExtraRow(detail: detail),
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
      GroupClassStatus.ongoing => ('تمرين جاري', AppColors.primary),
      GroupClassStatus.upcoming => ('تمرين قادم', AppColors.red100),
      GroupClassStatus.completed => ('تمرين مكتمل', AppColors.green200),
    };
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name, style: context.highlightBold),
        _Chip(label: label, color: color),
      ],
    );
  }
}

final class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});

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
      child: Text(label, style: context.footnoteRegular.copyWith(color: color)),
    );
  }
}

final class _StatusExtraRow extends StatelessWidget {
  const _StatusExtraRow({required this.detail});

  final _WorkoutDetailData detail;

  @override
  Widget build(BuildContext context) {
    if (detail.status == GroupClassStatus.completed && detail.endDate != null) {
      return IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _DetailColumn(
                label: 'تاريخ الانتهاء',
                value: detail.endDate!,
              ),
            ),
          ],
        ),
      );
    }
    if (detail.status == GroupClassStatus.ongoing &&
        detail.createdDate != null &&
        detail.daysRemaining != null) {
      return IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _DetailColumn(
                label: 'عدد الايام المتبقية',
                value: detail.daysRemaining!,
              ),
            ),
            const VerticalDivider(width: 1, color: AppColors.neutral200),
            Expanded(
              child: _DetailColumn(
                label: 'تاريخ الانشاء',
                value: detail.createdDate!,
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

final class _ThreeColumnRow extends StatelessWidget {
  const _ThreeColumnRow({
    required this.col1,
    required this.col2,
    required this.col3,
  });

  final ({String label, String value}) col1;
  final ({String label, String value}) col2;
  final ({String label, String value}) col3;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _DetailColumn(label: col1.label, value: col1.value),
          ),
          const VerticalDivider(width: 1, color: AppColors.neutral200),
          Expanded(
            child: _DetailColumn(label: col2.label, value: col2.value),
          ),
          const VerticalDivider(width: 1, color: AppColors.neutral200),
          Expanded(
            child: _DetailColumn(label: col3.label, value: col3.value),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

final class _PhaseCard extends StatelessWidget {
  const _PhaseCard({required this.phase, this.onAddWeight});

  final _WorkoutPhase phase;
  final VoidCallback? onAddWeight;

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
          _PhaseDetailsRow(phase: phase),
          const SizedBox(height: 12),
          _PhaseImage(
            imageAsset: phase.imageAsset,
            showPlayButton: phase.showPlayButton,
          ),
          if (onAddWeight != null) ...[
            const SizedBox(height: 12),
            AppButton(
              label: 'اضافة وزن',
              variant: AppButtonVariant.outlined,
              height: 48,
              onPressed: onAddWeight,
            ),
          ],
        ],
      ),
    );
  }
}

final class _PhaseDetailsRow extends StatelessWidget {
  const _PhaseDetailsRow({required this.phase});

  final _WorkoutPhase phase;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _DetailColumn(label: phase.phaseLabel, value: phase.type),
          ),
          const VerticalDivider(width: 1, color: AppColors.neutral200),
          Expanded(
            child: _DetailColumn(
              label: 'الوزن المقترح',
              value: phase.suggestedWeight,
            ),
          ),
          if (phase.actualWeight != null) ...[
            const VerticalDivider(width: 1, color: AppColors.neutral200),
            Expanded(
              child: _DetailColumn(
                label: 'الوزن اللعب',
                value: phase.actualWeight!,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

final class _PhaseImage extends StatelessWidget {
  const _PhaseImage({required this.imageAsset, this.showPlayButton = false});

  final String imageAsset;
  final bool showPlayButton;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: double.infinity,
        height: 160,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(imageAsset, fit: BoxFit.cover),
            if (showPlayButton)
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
      children: [
        Text(
          label,
          style: context.footnoteRegular.copyWith(color: AppColors.neutral400),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(value, style: context.subtitleMedium, textAlign: TextAlign.center),
      ],
    );
  }
}
