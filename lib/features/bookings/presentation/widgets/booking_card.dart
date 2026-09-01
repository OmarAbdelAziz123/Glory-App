import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';

// ── Model ─────────────────────────────────────────────────────────────────────

final class BookingItem {
  const BookingItem({
    required this.packageName,
    required this.type,
    required this.trainerName,
    required this.date,
    required this.time,
    this.canCheckIn = false,
    this.canCancel = false,
    this.canRate = false,
    this.isCheckedIn = false,
    this.trainerAvatarAsset,
    this.onCheckIn,
    this.onCancel,
    this.onEvaluate,
  });

  final String packageName;
  final String type;
  final String trainerName;
  final String date;
  final String time;
  final bool canCheckIn;
  final bool canCancel;
  final bool canRate;
  final bool isCheckedIn;
  final String? trainerAvatarAsset;
  final VoidCallback? onCheckIn;
  final VoidCallback? onCancel;
  final VoidCallback? onEvaluate;
}

// ── Public widget ─────────────────────────────────────────────────────────────

final class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.item});

  final BookingItem item;

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
          _CardHeader(
            packageName: item.packageName,
            type: item.type,
            showEvaluate: item.canRate,
            onPressed: item.onEvaluate,
          ),
          const Divider(height: 1, color: AppColors.neutral200),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _DetailsRow(
                  trainerName: item.trainerName,
                  date: item.date,
                  time: item.time,
                ),
                const SizedBox(height: 16),
                _ActionRow(
                  canCheckIn: item.canCheckIn,
                  canCancel: item.canCancel,
                  onCheckIn: item.onCheckIn,
                  onCancel: item.onCancel,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Private widgets ───────────────────────────────────────────────────────────

final class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.packageName,
    required this.type,
    required this.showEvaluate,
    required this.onPressed,
  });

  final String packageName;
  final String type;
  final bool showEvaluate;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/pngs/bg_image_on_appbar.png',
            width: 80,
            height: 80,
            fit: BoxFit.contain,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(packageName, style: context.highlightBold),
                const SizedBox(height: 8),
                _TypeChip(label: type),
              ],
            ),
          ),
          if (showEvaluate)
            TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                context.l10n.trainingEvaluation,
                style: context.captionBold.copyWith(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

final class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.green200),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: context.footnoteRegular.copyWith(color: AppColors.green200),
      ),
    );
  }
}

final class _DetailsRow extends StatelessWidget {
  const _DetailsRow({
    required this.trainerName,
    required this.date,
    required this.time,
  });

  final String trainerName;
  final String date;
  final String time;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _DetailColumn(label: context.l10n.instructorName, value: trainerName),
          ),
          const VerticalDivider(width: 1, color: AppColors.neutral200),
          Expanded(
            child: _DetailColumn(label: context.l10n.date, value: date),
          ),
          const VerticalDivider(width: 1, color: AppColors.neutral200),
          Expanded(
            child: _DetailColumn(label: context.l10n.time, value: time),
          ),
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

final class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.canCheckIn,
    required this.canCancel,
    this.onCheckIn,
    this.onCancel,
  });

  final bool canCheckIn;
  final bool canCancel;
  final VoidCallback? onCheckIn;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _CheckInButton(canCheckIn: canCheckIn, onTap: onCheckIn),
        ),
        // const SizedBox(width: 10),
        // Expanded(
        //   child: _CancelButton(canCancel: canCancel, onTap: onCancel),
        // ),
      ],
    );
  }
}

// final class _CancelButton extends StatelessWidget {
//   const _CancelButton({required this.canCancel, this.onTap});
//
//   final bool canCancel;
//   final VoidCallback? onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return AppButton(
//       label: context.l10n.cancelClass,
//       variant: AppButtonVariant.outlined,
//       height: 48,
//       onPressed: canCancel ? onTap : null,
//     );
//   }
// }

final class _CheckInButton extends StatelessWidget {
  const _CheckInButton({required this.canCheckIn, this.onTap});

  final bool canCheckIn;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: canCheckIn ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              canCheckIn ? AppColors.primary : AppColors.neutral300,
          disabledBackgroundColor: AppColors.neutral300,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          context.l10n.trainingCheckIn,
          style: context.captionRegular.copyWith(color: AppColors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
