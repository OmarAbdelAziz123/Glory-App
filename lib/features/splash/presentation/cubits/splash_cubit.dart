import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/repositories/auth_repository.dart';

part 'splash_state.dart';

final class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._authRepository) : super(const SplashState());

  final AuthRepository _authRepository;

  Future<void> checkSession() async {
    emit(state.copyWith(status: SplashStatus.checking));

    final result = await _authRepository.checkSession();

    result.fold(
      onSuccess: (isAuthenticated) => emit(
        state.copyWith(
          status: isAuthenticated
              ? SplashStatus.authenticated
              : SplashStatus.unauthenticated,
        ),
      ),
      onFailure: (_) => emit(
        state.copyWith(status: SplashStatus.unauthenticated),
      ),
    );
  }
}
