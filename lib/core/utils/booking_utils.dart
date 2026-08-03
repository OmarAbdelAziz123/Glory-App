import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../features/bookings/domain/entities/booking_entity.dart';
import '../../features/bookings/presentation/widgets/booking_card.dart';

abstract final class BookingUtils {
  static String typeLabel(String type) => switch (type) {
        'PT' => 'تدريب شخصي',
        'APPOINTMENT' => 'موعد',
        'CLASS' => 'حصة جماعية',
        'GYM' => 'جيم',
        _ => type,
      };

  static String packageName(BookingEntity booking, {String locale = 'ar'}) {
    return locale == 'ar' ? booking.packageNameAr : booking.packageNameEn;
  }

  static String formatDate(DateTime dateTime) {
    return DateFormat('d MMMM y', 'ar').format(dateTime.toLocal());
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat('h:mm a', 'en').format(dateTime.toLocal());
  }

  static BookingItem toBookingItem(
    BookingEntity booking, {
    required String locale,
    VoidCallback? onCheckIn,
    VoidCallback? onCancel,
    VoidCallback? onEvaluate,
  }) {
    final isCheckedIn = booking.checkedInAt != null;

    return BookingItem(
      packageName: packageName(booking, locale: locale),
      type: typeLabel(booking.type),
      trainerName: booking.instructorName,
      date: formatDate(booking.dateTime),
      time: formatTime(booking.dateTime),
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
