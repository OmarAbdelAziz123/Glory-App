import 'dart:convert';
import '../../../../core/l10n/fallback_messages.dart';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/result/result.dart';
import '../models/workout_api_responses.dart';
import '../models/workout_models.dart';
import 'workouts_api.dart';

final class WorkoutsRemoteApiService extends ApiService {
  WorkoutsRemoteApiService(super.dio, this._workoutsApi);

  final WorkoutsApi _workoutsApi;

  Future<Result<WorkoutAssignmentsApiResponse>> getWorkouts({
    int page = 1,
    int limit = 10,
    String? status,
    String? sortOrder,
  }) =>
      _guard(() async {
        final response = await _workoutsApi.getWorkouts(
          page: page,
          limit: limit,
          status: status,
          sortOrder: sortOrder,
        );
        _debugLogWorkoutsList(
          page: page,
          limit: limit,
          status: status,
          sortOrder: sortOrder,
          response: response,
        );
        if (!response.success) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return Success(response);
      });

  Future<Result<WorkoutAssignmentDetailModel>> getWorkoutById(String id) =>
      _guard(() async {
        final response = await _workoutsApi.getWorkoutById(id);
        return _mapDetailResponse(response);
      });

  Future<Result<List<WorkoutVideoModel>>> getWorkoutVideos(String id) =>
      _guard(() async {
        final response = await _workoutsApi.getWorkoutVideos(id);
        if (!response.success || response.data == null) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return Success(response.data!);
      });

  Future<Result<WorkoutAssignmentDetailModel>> addWorkoutWeight({
    required String id,
    required String weight,
  }) =>
      _guard(() async {
        final response = await _workoutsApi.addWorkoutWeight(
          id,
          AddWorkoutWeightRequest(weight: weight),
        );
        return _mapDetailResponse(response);
      });

  Result<WorkoutAssignmentDetailModel> _mapDetailResponse(
    WorkoutAssignmentApiResponse response,
  ) {
    if (!response.success || response.data == null) {
      return Failure(
        ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
      );
    }
    return Success(response.data!);
  }

  Future<Result<T>> _guard<T>(Future<Result<T>> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      final inner = e.error;
      if (inner is AppException) {
        return Failure(_mapException(inner));
      }
      return Failure(
        switch (e.type) {
          DioExceptionType.connectionTimeout ||
          DioExceptionType.receiveTimeout ||
          DioExceptionType.sendTimeout ||
          DioExceptionType.connectionError =>
            NetworkFailure(FallbackMessages.noInternet),
          _ => ServerFailure(e.message ?? FallbackMessages.errorGeneral),
        },
      );
    } on AppException catch (e) {
      return Failure(_mapException(e));
    } catch (e) {
      return Failure(ServerFailure(e.toString()));
    }
  }

  AppFailure _mapException(AppException e) => switch (e) {
        NetworkException() => NetworkFailure(e.message),
        UnauthorizedException() => UnauthorizedFailure(e.message),
        ServerException() => ServerFailure(e.message),
        CacheException() => CacheFailure(e.message),
        ValidationException() => ValidationFailure(e.message),
      };

  void _debugLogWorkoutsList({
    required int page,
    required int limit,
    required String? status,
    required String? sortOrder,
    required WorkoutAssignmentsApiResponse response,
  }) {
    if (!kDebugMode) return;

    final payload = <String, dynamic>{
      'success': response.success,
      'message': response.message,
      'meta': response.meta == null
          ? null
          : {
              'page': response.meta!.page,
              'limit': response.meta!.limit,
              'total': response.meta!.total,
              'totalPages': response.meta!.totalPages,
            },
      'data': response.data
          ?.map(
            (item) => {
              'id': item.id,
              'status': item.status,
              'workout': {
                'id': item.workout.id,
                'nameEn': item.workout.nameEn,
                'nameAr': item.workout.nameAr,
                'type': item.workout.type,
                'level': item.workout.level,
              },
              'startDate': item.startDate?.toIso8601String(),
              'endDate': item.endDate?.toIso8601String(),
              'durationDays': item.durationDays,
              'instructor': {
                'id': item.instructor.id,
                'fullName': item.instructor.fullName,
                'avatarUrl': item.instructor.avatarUrl,
              },
              'previewVideoUrl': item.previewVideoUrl,
              'previewThumbnailUrl': item.previewThumbnailUrl,
            },
          )
          .toList(),
    };

    debugPrint(
      '[GET /mobile/workouts?page=$page&limit=$limit'
      '${status != null ? '&status=$status' : ''}'
      '${sortOrder != null ? '&sortOrder=$sortOrder' : ''}] '
      '${const JsonEncoder.withIndent('  ').convert(payload)}',
    );
  }
}
