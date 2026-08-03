import 'package:json_annotation/json_annotation.dart';

part 'workout_models.g.dart';

@JsonSerializable()
final class WorkoutInfoModel {
  const WorkoutInfoModel({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.type,
    required this.level,
    this.durationDays,
  });

  factory WorkoutInfoModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutInfoModelFromJson(json);

  final String id;
  final String nameEn;
  final String nameAr;
  final String type;
  final String level;
  final int? durationDays;
}

@JsonSerializable()
final class WorkoutInstructorModel {
  const WorkoutInstructorModel({
    required this.id,
    required this.fullName,
    this.avatarUrl,
  });

  factory WorkoutInstructorModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutInstructorModelFromJson(json);

  final String id;
  final String fullName;
  final String? avatarUrl;
}

@JsonSerializable()
final class WorkoutVideoModel {
  const WorkoutVideoModel({
    required this.id,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.duration,
    this.stepNumber,
    this.instructionEn,
    this.instructionAr,
  });

  factory WorkoutVideoModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutVideoModelFromJson(json);

  final String id;
  final String videoUrl;
  final String thumbnailUrl;
  final String duration;
  final int? stepNumber;
  final String? instructionEn;
  final String? instructionAr;
}

@JsonSerializable()
final class WorkoutInstructionModel {
  const WorkoutInstructionModel({
    required this.id,
    required this.stepNumber,
    required this.instructionEn,
    required this.instructionAr,
    required this.videos,
  });

  factory WorkoutInstructionModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutInstructionModelFromJson(json);

  final String id;
  final int stepNumber;
  final String instructionEn;
  final String instructionAr;
  final List<WorkoutVideoModel> videos;
}

@JsonSerializable()
final class WorkoutAssignmentListModel {
  const WorkoutAssignmentListModel({
    required this.id,
    required this.status,
    required this.workout,
    this.startDate,
    this.endDate,
    required this.durationDays,
    required this.instructor,
    this.previewVideoUrl,
    this.previewThumbnailUrl,
  });

  factory WorkoutAssignmentListModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutAssignmentListModelFromJson(json);

  final String id;
  final String status;
  final WorkoutInfoModel workout;
  final DateTime? startDate;
  final DateTime? endDate;
  final int durationDays;
  final WorkoutInstructorModel instructor;
  final String? previewVideoUrl;
  final String? previewThumbnailUrl;
}

@JsonSerializable()
final class WorkoutAssignmentDetailModel {
  const WorkoutAssignmentDetailModel({
    required this.id,
    required this.status,
    this.startDate,
    this.endDate,
    required this.durationDays,
    this.remainingDays,
    this.suggestedWeight,
    this.suggestedWeightLast,
    this.userWeight,
    this.userWeightLast,
    required this.canAddWeight,
    required this.instructor,
    required this.workout,
    required this.instructions,
    required this.createdAt,
  });

  factory WorkoutAssignmentDetailModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutAssignmentDetailModelFromJson(json);

  final String id;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;
  final int durationDays;
  final int? remainingDays;
  final String? suggestedWeight;
  final String? suggestedWeightLast;
  final String? userWeight;
  final String? userWeightLast;
  final bool canAddWeight;
  final WorkoutInstructorModel instructor;
  final WorkoutInfoModel workout;
  final List<WorkoutInstructionModel> instructions;
  final DateTime createdAt;
}

@JsonSerializable()
final class AddWorkoutWeightRequest {
  const AddWorkoutWeightRequest({required this.weight});

  factory AddWorkoutWeightRequest.fromJson(Map<String, dynamic> json) =>
      _$AddWorkoutWeightRequestFromJson(json);

  final String weight;

  Map<String, dynamic> toJson() => _$AddWorkoutWeightRequestToJson(this);
}
