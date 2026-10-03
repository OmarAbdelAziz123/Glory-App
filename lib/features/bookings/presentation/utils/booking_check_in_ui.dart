import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/core.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/booking_entity.dart';

abstract final class BookingCheckInUi {
  static void showSuccessSheet(
    BuildContext context, {
    required BookingCheckInResultEntity result,
    VoidCallback? onDismiss,
    bool offerRating = true,
  }) {
    AppSuccessSheet.show(
      context,
      title: context.l10n.trainingCheckIn,
      headline: context.l10n.classCheckInSuccess,
      highlightWord: context.l10n.successfully,
      description:
          '${context.l10n.checkinClassWelcomePrefix(result.packageNameAr)}'
          '${context.l10n.checkinClassWelcomeSuffix(result.instructorName, '${result.remainingSessions}')}',
      buttonLabel: offerRating ? context.l10n.evaluateClass : context.l10n.home,
      badgeAsset:
          'assets/images/svgs/success_when_create_anew_password_icon.svg',
      onButtonPressed: () {
        Navigator.of(context).pop();
        onDismiss?.call();
        if (offerRating) {
          context.push(AppRoutes.classEvaluation, extra: result.bookingId);
        }
      },
    );
  }
}
