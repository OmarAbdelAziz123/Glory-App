import '../../../../core/result/result.dart';
import '../entities/nutrition_plan_entities.dart';

abstract interface class NutritionPlansRepository {
  Future<Result<NutritionPlanEntity?>> getCurrentPlan();

  Future<Result<NutritionPlansPageEntity>> getPlans({
    int page = 1,
    int limit = 20,
  });

  Future<Result<NutritionPlanEntity>> getPlanById(String id);
}
