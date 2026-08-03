import 'package:json_annotation/json_annotation.dart';

import '../../../../core/network/models/pagination_meta_model.dart';
import 'workout_models.dart';

part 'workout_api_responses.g.dart';

@JsonSerializable()
final class WorkoutAssignmentsApiResponse {
  const WorkoutAssignmentsApiResponse({
    required this.success,
    this.data,
    this.meta,
    this.message,
  });

  factory WorkoutAssignmentsApiResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkoutAssignmentsApiResponseFromJson(json);

  final bool success;
  final List<WorkoutAssignmentListModel>? data;
  final PaginationMetaModel? meta;
  final String? message;
}

@JsonSerializable()
final class WorkoutAssignmentApiResponse {
  const WorkoutAssignmentApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory WorkoutAssignmentApiResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkoutAssignmentApiResponseFromJson(json);

  final bool success;
  final WorkoutAssignmentDetailModel? data;
  final String? message;
}

@JsonSerializable()
final class WorkoutVideosApiResponse {
  const WorkoutVideosApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory WorkoutVideosApiResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkoutVideosApiResponseFromJson(json);

  final bool success;
  final List<WorkoutVideoModel>? data;
  final String? message;
}
