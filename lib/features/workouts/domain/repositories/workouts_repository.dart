import '../../../../core/result/result.dart';
import '../entities/workout_entity.dart';

abstract interface class WorkoutsRepository {
  Future<Result<List<WorkoutEntity>>> getWorkouts();

  Future<Result<WorkoutEntity>> getWorkoutById(String id);
}
