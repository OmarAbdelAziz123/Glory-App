part of 'session_checkin_scan_cubit.dart';

enum SessionCheckinScanStatus { idle, submitting, success, failure }

final class SessionCheckinScanState extends Equatable {
  const SessionCheckinScanState({
    this.status = SessionCheckinScanStatus.idle,
    this.booking,
    this.failure,
  });

  final SessionCheckinScanStatus status;
  final BookingEntity? booking;
  final AppFailure? failure;

  bool get isSubmitting => status == SessionCheckinScanStatus.submitting;

  SessionCheckinScanState copyWith({
    SessionCheckinScanStatus? status,
    BookingEntity? booking,
    AppFailure? failure,
    bool clearBooking = false,
    bool clearFailure = false,
  }) {
    return SessionCheckinScanState(
      status: status ?? this.status,
      booking: clearBooking ? null : (booking ?? this.booking),
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [status, booking, failure];
}
