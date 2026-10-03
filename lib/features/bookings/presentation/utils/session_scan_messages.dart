import '../../../../core/error/app_failure.dart';
import '../../../../l10n/app_localizations.dart';

abstract final class SessionScanMessages {
  static String forFailure(AppLocalizations l10n, AppFailure failure) {
    if (failure is ScanBookingFailure && failure.preferServerMessage) {
      return failure.message;
    }

    if (failure is ScanBookingFailure) {
      return switch (failure.kind) {
        ScanBookingErrorKind.invalidCode => l10n.ptScanInvalidCode,
        ScanBookingErrorKind.alreadyUsed => l10n.ptScanAlreadyUsed,
        ScanBookingErrorKind.expired => l10n.ptScanExpired,
        ScanBookingErrorKind.notYourSession => l10n.ptScanNotYourSession,
        ScanBookingErrorKind.bookingState => failure.message,
        ScanBookingErrorKind.outstandingBalance => failure.message,
        ScanBookingErrorKind.unknown => failure.message,
      };
    }

    return failure.message;
  }
}
