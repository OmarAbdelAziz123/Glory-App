import 'package:dio/dio.dart';

import '../../../../core/error/app_failure.dart';

abstract final class ScanBookingErrorMapper {
  static ScanBookingFailure fromDio(DioException e) {
    final status = e.response?.statusCode;
    final message = _extractMessage(e.response?.data);
    final lower = message?.toLowerCase() ?? '';

    if (status == 404) {
      return ScanBookingFailure(kind: ScanBookingErrorKind.invalidCode);
    }

    if (status == 403) {
      if (_looksLikeBalance(lower)) {
        return ScanBookingFailure(
          kind: ScanBookingErrorKind.outstandingBalance,
          message: message,
        );
      }
      return ScanBookingFailure(kind: ScanBookingErrorKind.notYourSession);
    }

    if (status == 400) {
      if (lower.contains('already used') || lower.contains('already_used')) {
        return ScanBookingFailure(kind: ScanBookingErrorKind.alreadyUsed);
      }
      if (lower.contains('expired')) {
        return ScanBookingFailure(kind: ScanBookingErrorKind.expired);
      }
      return ScanBookingFailure(
        kind: ScanBookingErrorKind.bookingState,
        message: message,
      );
    }

    return ScanBookingFailure(
      kind: ScanBookingErrorKind.unknown,
      message: message,
    );
  }

  static bool _looksLikeBalance(String lower) {
    return lower.contains('balance') ||
        lower.contains('outstanding') ||
        lower.contains('unpaid') ||
        lower.contains('مديون') ||
        lower.contains('رصيد');
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) return message;
    }
    return null;
  }
}
