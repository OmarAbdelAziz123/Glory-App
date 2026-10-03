import '../../../../core/result/result.dart';
import '../../domain/entities/nutrition_plan_entities.dart';
import '../../domain/repositories/nutrition_plans_repository.dart';
import '../datasources/nutrition_plans_remote_api_service.dart';

final class NutritionPlansRepositoryImpl implements NutritionPlansRepository {
  const NutritionPlansRepositoryImpl(this._remote);

  final NutritionPlansRemoteApiService _remote;

  @override
  Future<Result<NutritionPlanEntity?>> getCurrentPlan() =>
      _remote.getCurrentPlan();

  @override
  Future<Result<NutritionPlansPageEntity>> getPlans({
    int page = 1,
    int limit = 20,
  }) =>
      _remote.getPlans(page: page, limit: limit);

  @override
  Future<Result<NutritionPlanEntity>> getPlanById(String id) =>
      _remote.getPlanById(id);
}
