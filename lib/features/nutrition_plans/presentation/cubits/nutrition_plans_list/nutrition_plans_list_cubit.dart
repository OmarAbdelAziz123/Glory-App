import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/nutrition_plan_entities.dart';
import '../../../domain/repositories/nutrition_plans_repository.dart';

part 'nutrition_plans_list_state.dart';

final class NutritionPlansListCubit extends Cubit<NutritionPlansListState> {
  NutritionPlansListCubit(this._repository)
      : super(const NutritionPlansListState());

  final NutritionPlansRepository _repository;

  Future<void> load({bool refresh = false, int limit = 20}) async {
    emit(
      state.copyWith(
        status: NutritionPlansListStatus.loading,
        clearError: true,
        plans: refresh ? const [] : state.plans,
        page: 1,
      ),
    );

    final result = await _repository.getPlans(page: 1, limit: limit);

    result.fold(
      onSuccess: (page) => emit(
        state.copyWith(
          status: NutritionPlansListStatus.loaded,
          plans: page.items,
          page: page.page,
          totalPages: page.totalPages,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: NutritionPlansListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> loadMore({int limit = 20}) async {
    if (!state.hasMore || state.isLoadingMore || state.isLoading) return;

    emit(state.copyWith(status: NutritionPlansListStatus.loadingMore));

    final nextPage = state.page + 1;
    final result = await _repository.getPlans(page: nextPage, limit: limit);

    result.fold(
      onSuccess: (page) => emit(
        state.copyWith(
          status: NutritionPlansListStatus.loaded,
          plans: [...state.plans, ...page.items],
          page: page.page,
          totalPages: page.totalPages,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: NutritionPlansListStatus.loaded,
          errorMessage: failure.message,
        ),
      ),
    );
  }
}
