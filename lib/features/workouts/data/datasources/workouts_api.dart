import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/endpoints.dart';
import '../models/workout_api_responses.dart';
import '../models/workout_models.dart';

part 'workouts_api.g.dart';

@RestApi()
abstract class WorkoutsApi {
  factory WorkoutsApi(Dio dio, {String baseUrl}) = _WorkoutsApi;

  @GET(Endpoints.mobileWorkouts)
  Future<WorkoutAssignmentsApiResponse> getWorkouts({
    @Query('page') int page = 1,
    @Query('limit') int limit = 10,
    @Query('status') String? status,
    @Query('sortOrder') String? sortOrder,
  });

  @GET(Endpoints.mobileWorkoutById)
  Future<WorkoutAssignmentApiResponse> getWorkoutById(@Path('id') String id);

  @GET(Endpoints.mobileWorkoutVideos)
  Future<WorkoutVideosApiResponse> getWorkoutVideos(@Path('id') String id);

  @POST(Endpoints.mobileWorkoutWeight)
  Future<WorkoutAssignmentApiResponse> addWorkoutWeight(
    @Path('id') String id,
    @Body() AddWorkoutWeightRequest body,
  );
}
