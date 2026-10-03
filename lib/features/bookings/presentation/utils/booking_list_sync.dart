import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/booking_entity.dart';
import '../cubits/booking_detail/booking_detail_cubit.dart';
import '../cubits/bookings_list/bookings_list_cubit.dart';

/// Applies a booking returned from scan/check-in to any open list/detail cubits.
abstract final class BookingListSync {
  static void apply(BuildContext context, BookingEntity booking) {
    try {
      context.read<BookingsListCubit>().upsertBooking(booking);
    } catch (_) {}
    try {
      final detail = context.read<BookingDetailCubit>();
      if (detail.bookingId == booking.id) {
        detail.applyBooking(booking);
      }
    } catch (_) {}
  }
}
