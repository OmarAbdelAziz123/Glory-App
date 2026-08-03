import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/auth_repository.dart';

part 'logout_state.dart';

final class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit(this._repository) : super(const LogoutState());

  final AuthRepository _repository;

  Future<void> logout() async {
    emit(state.copyWith(status: LogoutStatus.loading, errorMessage: null));

    final result = await _repository.logout();

    result.fold(
      onSuccess: (_) => emit(state.copyWith(status: LogoutStatus.success)),
      onFailure: (failure) => emit(
        state.copyWith(
          status: LogoutStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  void reset() => emit(const LogoutState());
}
