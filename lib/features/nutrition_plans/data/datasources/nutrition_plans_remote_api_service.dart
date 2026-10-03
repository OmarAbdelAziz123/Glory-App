import '../../../../core/error/app_failure.dart';
import '../../../../core/l10n/fallback_messages.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/nutrition_plan_entities.dart';
import '../models/nutrition_plan_models.dart';

final class NutritionPlansRemoteApiService extends ApiService {
  const NutritionPlansRemoteApiService(super.dio);

  Future<Result<NutritionPlanEntity?>> getCurrentPlan() => _readNullable(
        Endpoints.mobileNutritionPlansCurrent,
        parse: readNutritionPlanNullable,
      );

  Future<Result<NutritionPlansPageEntity>> getPlans({
    int page = 1,
    int limit = 20,
  }) =>
      get<Map<String, dynamic>>(
        Endpoints.mobileNutritionPlans,
        queryParameters: {'page': page, 'limit': limit},
        fromJson: (json) => asStringKeyedMap(json),
      ).then((result) {
        return result.when(
          success: (map) {
            if (map['success'] == false) {
              return Failure(
                ServerFailure(
                  map['message']?.toString() ?? FallbackMessages.errorTryAgain,
                ),
              );
            }
            return Success(readNutritionPlansPage(map));
          },
          failure: Failure.new,
        );
      });

  Future<Result<NutritionPlanEntity>> getPlanById(String id) => _read(
        Endpoints.mobileNutritionPlansById.replaceFirst('{id}', id),
        parse: readNutritionPlan,
      );

  Future<Result<T>> _read<T>(
    String path, {
    required T Function(dynamic data) parse,
  }) {
    return get<Map<String, dynamic>>(
      path,
      fromJson: (json) => asStringKeyedMap(json),
    ).then((result) {
      return result.when(
        success: (map) {
          if (map['success'] == false) {
            return Failure(
              ServerFailure(
                map['message']?.toString() ?? FallbackMessages.errorTryAgain,
              ),
            );
          }
          final payload = map.containsKey('data') ? map['data'] : map;
          return Success(parse(payload));
        },
        failure: Failure.new,
      );
    });
  }

  Future<Result<T>> _readNullable<T>(
    String path, {
    required T Function(dynamic data) parse,
  }) {
    return get<Map<String, dynamic>>(
      path,
      fromJson: (json) => asStringKeyedMap(json),
    ).then((result) {
      return result.when(
        success: (map) {
          if (map['success'] == false) {
            return Failure(
              ServerFailure(
                map['message']?.toString() ?? FallbackMessages.errorTryAgain,
              ),
            );
          }
          final payload = map.containsKey('data') ? map['data'] : map;
          return Success(parse(payload));
        },
        failure: Failure.new,
      );
    });
  }
}
