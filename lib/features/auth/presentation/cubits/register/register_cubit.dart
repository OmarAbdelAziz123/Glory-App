import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/otp_sent_entity.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'register_state.dart';

final class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._repository) : super(const RegisterState());

  final AuthRepository _repository;

  Future<void> register({
    required String fullName,
    required String phoneCountryCode,
    required String phone,
    required String email,
  }) async {
    emit(state.copyWith(status: RegisterStatus.loading, errorMessage: null));

    final result = await _repository.register(
      fullName: fullName,
      phoneCountryCode: phoneCountryCode,
      phone: phone,
      email: email,
    );

    result.fold(
      onSuccess: (data) => emit(
        state.copyWith(status: RegisterStatus.success, otpSent: data),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  void reset() => emit(const RegisterState());
}
