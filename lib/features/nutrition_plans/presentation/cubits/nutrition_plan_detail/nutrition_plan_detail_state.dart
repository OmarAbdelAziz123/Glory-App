part of 'nutrition_plan_detail_cubit.dart';

enum NutritionPlanDetailStatus { initial, loading, loaded, failure }

final class NutritionPlanDetailState extends Equatable {
  const NutritionPlanDetailState({
    this.status = NutritionPlanDetailStatus.initial,
    this.plan,
    this.errorMessage,
  });

  final NutritionPlanDetailStatus status;
  final NutritionPlanEntity? plan;
  final String? errorMessage;

  bool get isLoading => status == NutritionPlanDetailStatus.loading;

  NutritionPlanDetailState copyWith({
    NutritionPlanDetailStatus? status,
    NutritionPlanEntity? plan,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NutritionPlanDetailState(
      status: status ?? this.status,
      plan: plan ?? this.plan,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, plan, errorMessage];
}
