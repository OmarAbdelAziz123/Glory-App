import '../../../../core/result/result.dart';
import '../entities/workout_entity.dart';

abstract interface class WorkoutsRepository {
  Future<Result<WorkoutsPageEntity>> getWorkouts({
    int page = 1,
    int limit = 10,
    String? status,
    String? sortOrder,
  });

  Future<Result<WorkoutAssignmentDetailEntity>> getWorkoutById(String id);

  Future<Result<List<WorkoutVideoEntity>>> getWorkoutVideos(String id);

  Future<Result<WorkoutAssignmentDetailEntity>> addWorkoutWeight({
    required String assignmentId,
    required String weight,
  });
}
