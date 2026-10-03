import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/app_failure.dart';
import '../../../../../core/l10n/fallback_messages.dart';
import '../../../domain/entities/booking_entity.dart';
import '../../../domain/repositories/bookings_repository.dart';
import '../../../domain/utils/session_checkin_token_parser.dart';

part 'session_checkin_scan_state.dart';

final class SessionCheckinScanCubit extends Cubit<SessionCheckinScanState> {
  SessionCheckinScanCubit(this._repository) : super(const SessionCheckinScanState());

  final BookingsRepository _repository;

  Future<bool> scan(String rawValue) async {
    final token = SessionCheckinTokenParser.extract(rawValue);
    if (token.isEmpty) {
      emit(
        state.copyWith(
          status: SessionCheckinScanStatus.failure,
          failure: ValidationFailure(FallbackMessages.invalidQrCode),
          clearBooking: true,
        ),
      );
      return false;
    }

    emit(
      state.copyWith(
        status: SessionCheckinScanStatus.submitting,
        clearFailure: true,
        clearBooking: true,
      ),
    );

    final result = await _repository.scanSessionCheckin(token);

    return result.when(
      success: (booking) {
        emit(
          state.copyWith(
            status: SessionCheckinScanStatus.success,
            booking: booking,
          ),
        );
        return true;
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: SessionCheckinScanStatus.failure,
            failure: failure,
          ),
        );
        return false;
      },
    );
  }

  void reset() {
    emit(const SessionCheckinScanState());
  }
}
