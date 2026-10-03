part of 'nutrition_plan_current_cubit.dart';

enum NutritionPlanCurrentStatus { initial, loading, loaded, failure }

final class NutritionPlanCurrentState extends Equatable {
  const NutritionPlanCurrentState({
    this.status = NutritionPlanCurrentStatus.initial,
    this.plan,
    this.errorMessage,
  });

  final NutritionPlanCurrentStatus status;
  final NutritionPlanEntity? plan;
  final String? errorMessage;

  bool get isLoading => status == NutritionPlanCurrentStatus.loading;

  NutritionPlanCurrentState copyWith({
    NutritionPlanCurrentStatus? status,
    NutritionPlanEntity? plan,
    bool clearPlan = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NutritionPlanCurrentState(
      status: status ?? this.status,
      plan: clearPlan ? null : plan ?? this.plan,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, plan, errorMessage];
}
