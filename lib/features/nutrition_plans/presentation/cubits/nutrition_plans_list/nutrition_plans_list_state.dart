part of 'nutrition_plans_list_cubit.dart';

enum NutritionPlansListStatus { initial, loading, loaded, loadingMore, failure }

final class NutritionPlansListState extends Equatable {
  const NutritionPlansListState({
    this.status = NutritionPlansListStatus.initial,
    this.plans = const [],
    this.page = 1,
    this.totalPages = 1,
    this.errorMessage,
  });

  final NutritionPlansListStatus status;
  final List<NutritionPlanEntity> plans;
  final int page;
  final int totalPages;
  final String? errorMessage;

  bool get isLoading => status == NutritionPlansListStatus.loading;
  bool get isLoadingMore => status == NutritionPlansListStatus.loadingMore;
  bool get hasMore => page < totalPages;

  NutritionPlansListState copyWith({
    NutritionPlansListStatus? status,
    List<NutritionPlanEntity>? plans,
    int? page,
    int? totalPages,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NutritionPlansListState(
      status: status ?? this.status,
      plans: plans ?? this.plans,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, plans, page, totalPages, errorMessage];
}
