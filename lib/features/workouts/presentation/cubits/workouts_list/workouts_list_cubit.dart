import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/workout_entity.dart';
import '../../../domain/repositories/workouts_repository.dart';

part 'workouts_list_state.dart';

final class WorkoutsListCubit extends Cubit<WorkoutsListState> {
  WorkoutsListCubit(this._repository) : super(const WorkoutsListState());

  final WorkoutsRepository _repository;

  Future<void> loadWorkouts({bool refresh = false, int limit = 10}) async {
    emit(
      state.copyWith(
        status: WorkoutsListStatus.loading,
        errorMessage: null,
        workouts: refresh ? [] : state.workouts,
        page: 1,
      ),
    );

    final result = await _repository.getWorkouts(limit: limit);

    result.fold(
      onSuccess: (page) => emit(
        state.copyWith(
          status: WorkoutsListStatus.loaded,
          workouts: page.items,
          page: page.page,
          totalPages: page.totalPages,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: WorkoutsListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore || state.isLoading) return;

    emit(state.copyWith(status: WorkoutsListStatus.loadingMore));

    final nextPage = state.page + 1;
    final result = await _repository.getWorkouts(page: nextPage);

    result.fold(
      onSuccess: (page) => emit(
        state.copyWith(
          status: WorkoutsListStatus.loaded,
          workouts: [...state.workouts, ...page.items],
          page: page.page,
          totalPages: page.totalPages,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: WorkoutsListStatus.loaded,
          errorMessage: failure.message,
        ),
      ),
    );
  }
}
