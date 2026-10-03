import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/nutrition_plan_entities.dart';
import '../../../domain/repositories/nutrition_plans_repository.dart';

part 'nutrition_plan_current_state.dart';

final class NutritionPlanCurrentCubit extends Cubit<NutritionPlanCurrentState> {
  NutritionPlanCurrentCubit(this._repository)
      : super(const NutritionPlanCurrentState());

  final NutritionPlansRepository _repository;

  Future<void> load({bool refresh = false}) async {
    emit(
      state.copyWith(
        status: NutritionPlanCurrentStatus.loading,
        clearError: true,
        clearPlan: refresh,
      ),
    );

    final result = await _repository.getCurrentPlan();

    result.fold(
      onSuccess: (plan) => emit(
        state.copyWith(
          status: NutritionPlanCurrentStatus.loaded,
          plan: plan,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: NutritionPlanCurrentStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }
}
