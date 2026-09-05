import 'package:flutter/material.dart';
import 'package:glory_gym/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../features/bookings/domain/entities/booking_entity.dart';
import '../../features/bookings/presentation/widgets/booking_card.dart';

abstract final class BookingUtils {
  static String typeLabel(AppLocalizations l10n, String type) => switch (type) {
        'PT' => l10n.personalTraining,
        'APPOINTMENT' => l10n.appointment,
        'CLASS' => l10n.groupClass,
        'GYM' => l10n.gym,
        _ => type,
      };

  static String packageName(BookingEntity booking, {String locale = 'ar'}) {
    return locale == 'ar' ? booking.packageNameAr : booking.packageNameEn;
  }

  static String assessmentQuestionLabel(
    AssessmentQuestionEntity question, {
    String locale = 'ar',
  }) {
    return locale == 'ar' ? question.questionAr : question.questionEn;
  }

  static String formatDate(AppLocalizations l10n, DateTime dateTime) {
    return DateFormat('d MMMM y', l10n.localeName).format(dateTime.toLocal());
  }

  static String formatTime(AppLocalizations l10n, DateTime dateTime) {
    return DateFormat('h:mm a', l10n.localeName).format(dateTime.toLocal());
  }

  static BookingItem toBookingItem(
    BookingEntity booking, {
    required AppLocalizations l10n,
    required String locale,
    VoidCallback? onCheckIn,
    VoidCallback? onCancel,
    VoidCallback? onEvaluate,
  }) {
    final isCheckedIn = booking.checkedInAt != null;

    return BookingItem(
      packageName: packageName(booking, locale: locale),
      type: typeLabel(l10n, booking.type),
      trainerName: booking.instructorName,
      date: formatDate(l10n, booking.dateTime),
      time: formatTime(l10n, booking.dateTime),
      canCheckIn: booking.canCheckIn,
      canCancel: booking.canCancel,
      canRate: booking.canRate,
      isCheckedIn: isCheckedIn,
      onCheckIn: booking.canCheckIn ? onCheckIn : null,
      onCancel: booking.canCancel ? onCancel : null,
      onEvaluate: booking.canRate ? onEvaluate : null,
    );
  }

  static String localeFromAppLanguage(String? appLanguage) =>
      appLanguage == 'en' ? 'en' : 'ar';
}
