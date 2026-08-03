import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/member_entity.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'create_password_state.dart';

final class CreatePasswordCubit extends Cubit<CreatePasswordState> {
  CreatePasswordCubit(this._repository) : super(const CreatePasswordState());

  final AuthRepository _repository;

  Future<void> completeRegistration({
    required String otpToken,
    required String password,
    required String passwordConfirm,
  }) async {
    emit(
      state.copyWith(status: CreatePasswordStatus.loading, errorMessage: null),
    );

    final result = await _repository.completeRegistration(
      otpToken: otpToken,
      password: password,
      passwordConfirm: passwordConfirm,
    );

    result.fold(
      onSuccess: (member) => emit(
        state.copyWith(
          status: CreatePasswordStatus.success,
          member: member,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: CreatePasswordStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> resetPassword({
    required String otpToken,
    required String password,
    required String passwordConfirm,
  }) async {
    emit(
      state.copyWith(status: CreatePasswordStatus.loading, errorMessage: null),
    );

    final result = await _repository.resetPassword(
      otpToken: otpToken,
      password: password,
      passwordConfirm: passwordConfirm,
    );

    result.fold(
      onSuccess: (message) => emit(
        state.copyWith(
          status: CreatePasswordStatus.success,
          successMessage: message,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: CreatePasswordStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  void reset() => emit(const CreatePasswordState());
}
