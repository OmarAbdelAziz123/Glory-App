import '../../../../core/error/app_failure.dart';
import '../../../../core/l10n/fallback_messages.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/workout_entity.dart';
import '../../domain/repositories/workouts_repository.dart';
import '../datasources/workouts_remote_api_service.dart';
import '../mappers/workout_mappers.dart';
import '../models/workout_api_responses.dart';

final class WorkoutsRepositoryImpl implements WorkoutsRepository {
  const WorkoutsRepositoryImpl(this._remote);

  final WorkoutsRemoteApiService _remote;

  @override
  Future<Result<WorkoutsPageEntity>> getWorkouts({
    int page = 1,
    int limit = 10,
    String? status,
    String? sortOrder,
  }) async {
    final result = await _remote.getWorkouts(
      page: page,
      limit: limit,
      status: status,
      sortOrder: sortOrder,
    );

    return switch (result) {
      Success(:final data) => _mapPage(data),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<WorkoutAssignmentDetailEntity>> getWorkoutById(
    String id,
  ) async {
    final result = await _remote.getWorkoutById(id);
    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<List<WorkoutVideoEntity>>> getWorkoutVideos(String id) async {
    final result = await _remote.getWorkoutVideos(id);
    return switch (result) {
      Success(:final data) => Success(data.map((v) => v.toEntity()).toList()),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<WorkoutAssignmentDetailEntity>> addWorkoutWeight({
    required String assignmentId,
    required String weight,
  }) async {
    final result = await _remote.addWorkoutWeight(
      id: assignmentId,
      weight: weight,
    );

    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Failure(:final failure) => Failure(failure),
    };
  }

  Result<WorkoutsPageEntity> _mapPage(WorkoutAssignmentsApiResponse data) {
    final pageEntity = data.toPageEntity();
    if (pageEntity == null) {
      return Failure(ServerFailure(FallbackMessages.errorTryAgain));
    }
    return Success(pageEntity);
  }
}
