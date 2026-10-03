import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/sandy_repository.dart';

part 'sandy_nudges_state.dart';

final class SandyNudgesCubit extends Cubit<SandyNudgesState> {
  SandyNudgesCubit(this._repository) : super(const SandyNudgesState());

  final SandyRepository _repository;

  Future<void> load() async {
    emit(
      state.copyWith(
        status: SandyNudgesStatus.loading,
        clearError: true,
      ),
    );

    final result = await _repository.getNudgesEnabled();

    result.fold(
      onSuccess: (enabled) => emit(
        state.copyWith(
          status: SandyNudgesStatus.loaded,
          enabled: enabled,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: SandyNudgesStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> setEnabled(bool enabled) async {
    final previous = state.enabled;
    emit(
      state.copyWith(
        status: SandyNudgesStatus.updating,
        enabled: enabled,
        clearError: true,
      ),
    );

    final result = await _repository.setNudgesEnabled(enabled: enabled);

    result.fold(
      onSuccess: (confirmed) => emit(
        state.copyWith(
          status: SandyNudgesStatus.loaded,
          enabled: confirmed,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: SandyNudgesStatus.loaded,
          enabled: previous,
          errorMessage: failure.message,
        ),
      ),
    );
  }
}
