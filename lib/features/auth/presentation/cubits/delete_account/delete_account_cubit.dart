import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/otp_sent_entity.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'delete_account_state.dart';

final class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit(this._repository) : super(const DeleteAccountState());

  final AuthRepository _repository;

  Future<void> requestOtp() async {
    emit(
      state.copyWith(
        status: DeleteAccountStatus.requesting,
        clearError: true,
        clearOtpSent: true,
      ),
    );

    final result = await _repository.requestDeleteAccount();

    result.when(
      success: (data) => emit(
        state.copyWith(
          status: DeleteAccountStatus.otpSent,
          otpSent: data,
        ),
      ),
      failure: (failure) => emit(
        state.copyWith(
          status: DeleteAccountStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> confirmDeletion(String code) async {
    if (code.length != 6) return;

    emit(
      state.copyWith(
        status: DeleteAccountStatus.confirming,
        clearError: true,
      ),
    );

    final result = await _repository.confirmDeleteAccount(code: code);

    result.when(
      success: (_) => emit(state.copyWith(status: DeleteAccountStatus.deleted)),
      failure: (failure) => emit(
        state.copyWith(
          status: DeleteAccountStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> resendOtp() async {
    emit(
      state.copyWith(
        status: DeleteAccountStatus.resending,
        clearError: true,
      ),
    );

    final result = await _repository.requestDeleteAccount();

    result.when(
      success: (data) => emit(
        state.copyWith(
          status: DeleteAccountStatus.otpSent,
          otpSent: data,
        ),
      ),
      failure: (failure) => emit(
        state.copyWith(
          status: DeleteAccountStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  void resetActionStatus() {
    emit(
      state.copyWith(
        status: state.otpSent != null
            ? DeleteAccountStatus.otpSent
            : DeleteAccountStatus.initial,
        clearError: true,
      ),
    );
  }

  void reset() => emit(const DeleteAccountState());
}
