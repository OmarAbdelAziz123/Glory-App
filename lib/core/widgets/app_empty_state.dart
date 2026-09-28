import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../theme/app_colors.dart';
import '../theme/app_styles_extension.dart';
import 'app_entrance.dart';

/// Shared empty-state used across lists and tabs.
///
/// Centered by default. Pass [compact] in tight tabs (home QR / preview lists).
final class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.action,
    this.compact = false,
    this.animate = true,
  });

  final IconData icon;
  final String title;
  final String? description;
  final Widget? action;
  final bool compact;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final halo = compact ? 96.0 : 112.0;
    final badge = compact ? 72.0 : 84.0;
    final iconSize = compact ? 30.0 : 36.0;

    return Center(
      child: AppEntrance(
        animate: animate,
        offset: const Offset(0, 0.06),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 20 : 28,
            vertical: compact ? 8 : 16,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: halo,
                  height: halo,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withValues(alpha: 0.08),
                        ),
                      ),
                      Container(
                        width: badge,
                        height: badge,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primary100,
                              AppColors.primary200,
                            ],
                          ),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.28),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.16),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          icon,
                          size: iconSize,
                          color: AppColors.primary800,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: compact ? 16 : 20),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: context.highlightBold.copyWith(
                    color: AppColors.neutral900,
                  ),
                ),
                if (description != null && description!.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    description!,
                    textAlign: TextAlign.center,
                    style: context.captionRegular.copyWith(
                      color: AppColors.neutral500,
                      height: 1.55,
                    ),
                  ),
                ],
                if (action != null) ...[
                  SizedBox(height: compact ? 16 : 20),
                  action!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Common Iconsax icons for empty states so screens stay consistent.
abstract final class AppEmptyIcons {
  static const IconData qr = Iconsax.scan_barcode;
  static const IconData bookings = Iconsax.calendar_1;
  static const IconData workouts = Iconsax.weight;
  static const IconData inbody = Iconsax.chart_2;
  static const IconData measurements = Iconsax.ruler;
  static const IconData subscriptions = Iconsax.ticket;
  static const IconData coach = Iconsax.messages_2;
  static const IconData notifications = Iconsax.notification;
  static const IconData family = Iconsax.people;
  static const IconData documents = Iconsax.document_text;
  static const IconData chat = Iconsax.message_text_1;
}
