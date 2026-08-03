import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/auth_session_entity.dart';
import '../../../domain/entities/otp_sent_entity.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'otp_state.dart';

final class OtpCubit extends Cubit<OtpState> {
  OtpCubit(this._repository) : super(const OtpState());

  final AuthRepository _repository;

  Future<void> verifyOtp({
    required String email,
    required String purpose,
    required String code,
  }) async {
    emit(state.copyWith(status: OtpStatus.verifying, errorMessage: null));

    final result = await _repository.verifyOtp(
      email: email,
      purpose: purpose,
      code: code,
    );

    result.fold(
      onSuccess: (data) => emit(
        state.copyWith(
          status: OtpStatus.verified,
          verifyResult: data,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: OtpStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> resendOtp({
    required String email,
    required String purpose,
  }) async {
    emit(state.copyWith(status: OtpStatus.resending, errorMessage: null));

    final result = await _repository.resendOtp(
      email: email,
      purpose: purpose,
    );

    result.fold(
      onSuccess: (data) => emit(
        state.copyWith(
          status: OtpStatus.resent,
          otpSent: data,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: OtpStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  void resetActionStatus() {
    if (state.status == OtpStatus.failure ||
        state.status == OtpStatus.verified ||
        state.status == OtpStatus.resent) {
      emit(
        state.copyWith(
          status: OtpStatus.initial,
          errorMessage: null,
        ),
      );
    }
  }
}
