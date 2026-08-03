import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/widgets/app_button.dart';

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
  });

  final GroupClassItem item;
  final VoidCallback? onEvaluate;
  final bool showPlayButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.neutral200),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          _ClassImageHeader(
            imageAsset: item.imageAsset,
            thumbnailUrl: item.thumbnailUrl,
            showPlayButton: showPlayButton,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _TitleRow(className: item.className, status: item.status),
                const SizedBox(height: 12),
                const Divider(height: 1, color: AppColors.neutral200),
                const SizedBox(height: 12),
                _DetailsRow(
                  time: item.time,
                  classType: item.classType,
                  startDate: item.startDate,
                  issuedBy: item.issuedBy,
                ),
                if (onEvaluate != null) ...[
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'تقييم الحصة',
                    height: 48,
                    onPressed: onEvaluate,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Private widgets ───────────────────────────────────────────────────────────

final class _ClassImageHeader extends StatelessWidget {
  const _ClassImageHeader({
    required this.imageAsset,
    this.thumbnailUrl,
    this.showPlayButton = true,
  });

  final String imageAsset;
  final String? thumbnailUrl;
  final bool showPlayButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
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
          if (showPlayButton) const Center(child: _PlayButton()),
        ],
      ),
    );
  }
}

final class _PlayButton extends StatelessWidget {
  const _PlayButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.85),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.play_arrow_rounded,
        size: 32,
        color: AppColors.neutral900,
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(className, style: context.highlightBold),
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
    final (label, color) = switch (status) {
      GroupClassStatus.ongoing => ('تمرين جاري', AppColors.primary),
      GroupClassStatus.upcoming => ('تمرين قادم', AppColors.red100),
      GroupClassStatus.completed => ('تمرين مكتمل', AppColors.green200),
    };
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

final class _DetailsRow extends StatelessWidget {
  const _DetailsRow({
    required this.time,
    required this.classType,
    this.startDate,
    this.issuedBy,
  });

  final String time;
  final String classType;
  final String? startDate;
  final String? issuedBy;

  @override
  Widget build(BuildContext context) {
    final thirdLabel =
        issuedBy != null ? 'اصدرت بواسطة' : 'تاريخ البداية';
    final thirdValue = issuedBy ?? startDate;

    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(child: _DetailColumn(label: 'الوقت', value: time)),
          const VerticalDivider(width: 1, color: AppColors.neutral200),
          Expanded(child: _DetailColumn(label: 'نوع التمرين', value: classType)),
          if (thirdValue != null) ...[
            const VerticalDivider(width: 1, color: AppColors.neutral200),
            Expanded(
              child: _DetailColumn(label: thirdLabel, value: thirdValue),
            ),
          ],
        ],
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
