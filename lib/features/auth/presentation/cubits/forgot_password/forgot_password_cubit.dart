import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/otp_sent_entity.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'forgot_password_state.dart';

final class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._repository) : super(const ForgotPasswordState());

  final AuthRepository _repository;

  Future<void> requestOtp({required String identifier}) async {
    emit(state.copyWith(status: ForgotPasswordStatus.loading, errorMessage: null));

    final result = await _repository.forgotPassword(identifier: identifier);

    result.fold(
      onSuccess: (data) => emit(
        state.copyWith(status: ForgotPasswordStatus.success, otpSent: data),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  void reset() => emit(const ForgotPasswordState());
}
