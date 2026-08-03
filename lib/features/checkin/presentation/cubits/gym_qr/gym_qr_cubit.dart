import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/qr_session_entity.dart';
import '../../../domain/repositories/checkin_repository.dart';

part 'gym_qr_state.dart';

final class GymQrCubit extends Cubit<GymQrState> {
  GymQrCubit(this._repository) : super(const GymQrState());

  final CheckinRepository _repository;

  Timer? _countdownTimer;
  Timer? _pollTimer;

  Future<void> generateQr() async {
    _stopTimers();

    emit(
      state.copyWith(
        status: GymQrStatus.generating,
        errorMessage: null,
        clearDaysRemaining: true,
      ),
    );

    final result = await _repository.generateQr();

    result.fold(
      onSuccess: (session) {
        emit(
          state.copyWith(
            status: GymQrStatus.active,
            qrToken: session.token,
            qrId: session.id,
            secondsLeft: session.expiresInSeconds,
          ),
        );
        _startCountdown(session.expiresInSeconds);
        _startPolling(session.id);
      },
      onFailure: (failure) => emit(
        state.copyWith(
          status: GymQrStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  void _startCountdown(int seconds) {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }

      final next = state.secondsLeft - 1;
      if (next <= 0) {
        timer.cancel();
        if (state.status == GymQrStatus.active) {
          emit(state.copyWith(status: GymQrStatus.expired, secondsLeft: 0));
        }
        _pollTimer?.cancel();
        return;
      }

      emit(state.copyWith(secondsLeft: next));
    });
  }

  void _startPolling(String qrId) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      _pollStatus(qrId);
    });
  }

  Future<void> _pollStatus(String qrId) async {
    if (state.status != GymQrStatus.active) return;

    final result = await _repository.getQrStatus(qrId);

    result.fold(
      onSuccess: (status) {
        switch (status.status) {
          case QrSessionStatus.consumed:
            _stopTimers();
            emit(
              state.copyWith(
                status: GymQrStatus.consumed,
                daysRemaining: status.daysRemaining,
                secondsLeft: 0,
              ),
            );
          case QrSessionStatus.expired:
            _stopTimers();
            emit(
              state.copyWith(
                status: GymQrStatus.expired,
                secondsLeft: 0,
              ),
            );
          case QrSessionStatus.pending:
            break;
        }
      },
      onFailure: (_) {},
    );
  }

  void _stopTimers() {
    _countdownTimer?.cancel();
    _pollTimer?.cancel();
  }

  @override
  Future<void> close() {
    _stopTimers();
    return super.close();
  }
}
