import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../core/utils/camera_permission_utils.dart';
import '../../../checkin/presentation/screens/qr_scanner_screen.dart';
import '../../../../core/error/app_failure.dart';
import '../../domain/entities/booking_entity.dart';
import '../cubits/session_checkin_scan/session_checkin_scan_cubit.dart';
import 'booking_check_in_ui.dart';
import 'booking_list_sync.dart';
import 'session_scan_messages.dart';

abstract final class PtSessionScanFlow {
  static Future<void> openScannerAndSubmit(
    BuildContext context, {
    VoidCallback? onBookingUpdated,
  }) async {
    final granted = await CameraPermissionUtils.ensureGranted(context);
    if (!granted || !context.mounted) return;

    final l10n = context.l10n;
    final rawValue = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => QrScannerScreen(
          title: l10n.ptScanSessionTitle,
          instruction: l10n.ptScanCoachScreenHint,
        ),
      ),
    );

    if (rawValue == null || !context.mounted) return;

    final cubit = context.read<SessionCheckinScanCubit>();
    final success = await cubit.scan(rawValue);
    if (!context.mounted) return;

    if (success) {
      final booking = cubit.state.booking;
      if (booking != null) {
        BookingListSync.apply(context, booking);
        onBookingUpdated?.call();
        BookingCheckInUi.showSuccessSheet(
          context,
          result: booking.toCheckInResult(),
          offerRating: booking.canRate,
          onDismiss: () => cubit.reset(),
        );
      }
      return;
    }

    final failure = cubit.state.failure;
    if (failure != null) {
      final message = SessionScanMessages.forFailure(l10n, failure);
      final canRetry = failure is ScanBookingFailure &&
          switch (failure.kind) {
            ScanBookingErrorKind.invalidCode ||
            ScanBookingErrorKind.alreadyUsed ||
            ScanBookingErrorKind.expired ||
            ScanBookingErrorKind.outstandingBalance =>
              true,
            _ => false,
          };

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          action: canRetry
              ? SnackBarAction(
                  label: l10n.retry,
                  onPressed: () => openScannerAndSubmit(
                    context,
                    onBookingUpdated: onBookingUpdated,
                  ),
                )
              : null,
        ),
      );
    }
  }
}
