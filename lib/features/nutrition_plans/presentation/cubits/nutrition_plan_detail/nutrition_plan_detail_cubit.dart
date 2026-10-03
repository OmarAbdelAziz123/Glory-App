import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/nutrition_plan_entities.dart';
import '../../../domain/repositories/nutrition_plans_repository.dart';

part 'nutrition_plan_detail_state.dart';

final class NutritionPlanDetailCubit extends Cubit<NutritionPlanDetailState> {
  NutritionPlanDetailCubit(this._repository, {required this.planId})
      : super(const NutritionPlanDetailState());

  final NutritionPlansRepository _repository;
  final String planId;

  Future<void> load() async {
    emit(
      state.copyWith(
        status: NutritionPlanDetailStatus.loading,
        clearError: true,
      ),
    );

    final result = await _repository.getPlanById(planId);

    result.fold(
      onSuccess: (plan) => emit(
        state.copyWith(
          status: NutritionPlanDetailStatus.loaded,
          plan: plan,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: NutritionPlanDetailStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }
}
