import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/auth_session_entity.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'login_state.dart';

final class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._repository) : super(const LoginState());

  final AuthRepository _repository;

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    emit(state.copyWith(status: LoginStatus.loading, errorMessage: null));

    final result = await _repository.login(
      identifier: identifier,
      password: password,
    );

    result.fold(
      onSuccess: (session) => emit(
        state.copyWith(status: LoginStatus.success, session: session),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  void reset() => emit(const LoginState());
}
