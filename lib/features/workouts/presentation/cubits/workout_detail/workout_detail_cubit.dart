import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/workout_entity.dart';
import '../../../domain/repositories/workouts_repository.dart';

part 'workout_detail_state.dart';

final class WorkoutDetailCubit extends Cubit<WorkoutDetailState> {
  WorkoutDetailCubit(this._repository, {required this.assignmentId})
      : super(const WorkoutDetailState());

  final WorkoutsRepository _repository;
  final String assignmentId;

  Future<void> loadDetail() async {
    emit(
      state.copyWith(
        status: WorkoutDetailStatus.loading,
        errorMessage: null,
      ),
    );

    final result = await _repository.getWorkoutById(assignmentId);

    result.fold(
      onSuccess: (detail) => emit(
        state.copyWith(
          status: WorkoutDetailStatus.loaded,
          detail: detail,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: WorkoutDetailStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<bool> addWeight(String weight) async {
    emit(
      state.copyWith(
        status: WorkoutDetailStatus.submittingWeight,
        errorMessage: null,
      ),
    );

    final result = await _repository.addWorkoutWeight(
      assignmentId: assignmentId,
      weight: weight,
    );

    return result.when(
      success: (detail) {
        emit(
          state.copyWith(
            status: WorkoutDetailStatus.loaded,
            detail: detail,
          ),
        );
        return true;
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: WorkoutDetailStatus.loaded,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
    );
  }
}
