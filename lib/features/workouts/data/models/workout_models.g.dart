// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutInfoModel _$WorkoutInfoModelFromJson(Map<String, dynamic> json) =>
    WorkoutInfoModel(
      id: json['id'] as String,
      nameEn: json['nameEn'] as String,
      nameAr: json['nameAr'] as String,
      type: json['type'] as String,
      level: json['level'] as String,
      durationDays: (json['durationDays'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WorkoutInfoModelToJson(WorkoutInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameEn': instance.nameEn,
      'nameAr': instance.nameAr,
      'type': instance.type,
      'level': instance.level,
      'durationDays': instance.durationDays,
    };

WorkoutInstructorModel _$WorkoutInstructorModelFromJson(
  Map<String, dynamic> json,
) => WorkoutInstructorModel(
  id: json['id'] as String,
  fullName: json['fullName'] as String,
  avatarUrl: json['avatarUrl'] as String?,
);

Map<String, dynamic> _$WorkoutInstructorModelToJson(
  WorkoutInstructorModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'avatarUrl': instance.avatarUrl,
};

WorkoutVideoModel _$WorkoutVideoModelFromJson(Map<String, dynamic> json) =>
    WorkoutVideoModel(
      id: json['id'] as String,
      videoUrl: json['videoUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      duration: json['duration'] as String,
      stepNumber: (json['stepNumber'] as num?)?.toInt(),
      instructionEn: json['instructionEn'] as String?,
      instructionAr: json['instructionAr'] as String?,
    );

Map<String, dynamic> _$WorkoutVideoModelToJson(WorkoutVideoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'videoUrl': instance.videoUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'duration': instance.duration,
      'stepNumber': instance.stepNumber,
      'instructionEn': instance.instructionEn,
      'instructionAr': instance.instructionAr,
    };

WorkoutInstructionModel _$WorkoutInstructionModelFromJson(
  Map<String, dynamic> json,
) => WorkoutInstructionModel(
  id: json['id'] as String,
  stepNumber: (json['stepNumber'] as num).toInt(),
  instructionEn: json['instructionEn'] as String,
  instructionAr: json['instructionAr'] as String,
  videos: (json['videos'] as List<dynamic>)
      .map((e) => WorkoutVideoModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$WorkoutInstructionModelToJson(
  WorkoutInstructionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'stepNumber': instance.stepNumber,
  'instructionEn': instance.instructionEn,
  'instructionAr': instance.instructionAr,
  'videos': instance.videos,
};

WorkoutAssignmentListModel _$WorkoutAssignmentListModelFromJson(
  Map<String, dynamic> json,
) => WorkoutAssignmentListModel(
  id: json['id'] as String,
  status: json['status'] as String,
  workout: WorkoutInfoModel.fromJson(json['workout'] as Map<String, dynamic>),
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  durationDays: (json['durationDays'] as num).toInt(),
  instructor: WorkoutInstructorModel.fromJson(
    json['instructor'] as Map<String, dynamic>,
  ),
  previewVideoUrl: json['previewVideoUrl'] as String?,
  previewThumbnailUrl: json['previewThumbnailUrl'] as String?,
);

Map<String, dynamic> _$WorkoutAssignmentListModelToJson(
  WorkoutAssignmentListModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': instance.status,
  'workout': instance.workout,
  'startDate': instance.startDate?.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'durationDays': instance.durationDays,
  'instructor': instance.instructor,
  'previewVideoUrl': instance.previewVideoUrl,
  'previewThumbnailUrl': instance.previewThumbnailUrl,
};

WorkoutAssignmentDetailModel _$WorkoutAssignmentDetailModelFromJson(
  Map<String, dynamic> json,
) => WorkoutAssignmentDetailModel(
  id: json['id'] as String,
  status: json['status'] as String,
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  durationDays: (json['durationDays'] as num).toInt(),
  remainingDays: (json['remainingDays'] as num?)?.toInt(),
  suggestedWeight: json['suggestedWeight'] as String?,
  suggestedWeightLast: json['suggestedWeightLast'] as String?,
  userWeight: json['userWeight'] as String?,
  userWeightLast: json['userWeightLast'] as String?,
  canAddWeight: json['canAddWeight'] as bool,
  instructor: WorkoutInstructorModel.fromJson(
    json['instructor'] as Map<String, dynamic>,
  ),
  workout: WorkoutInfoModel.fromJson(json['workout'] as Map<String, dynamic>),
  instructions: (json['instructions'] as List<dynamic>)
      .map((e) => WorkoutInstructionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$WorkoutAssignmentDetailModelToJson(
  WorkoutAssignmentDetailModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': instance.status,
  'startDate': instance.startDate?.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'durationDays': instance.durationDays,
  'remainingDays': instance.remainingDays,
  'suggestedWeight': instance.suggestedWeight,
  'suggestedWeightLast': instance.suggestedWeightLast,
  'userWeight': instance.userWeight,
  'userWeightLast': instance.userWeightLast,
  'canAddWeight': instance.canAddWeight,
  'instructor': instance.instructor,
  'workout': instance.workout,
  'instructions': instance.instructions,
  'createdAt': instance.createdAt.toIso8601String(),
};

AddWorkoutWeightRequest _$AddWorkoutWeightRequestFromJson(
  Map<String, dynamic> json,
) => AddWorkoutWeightRequest(weight: json['weight'] as String);

Map<String, dynamic> _$AddWorkoutWeightRequestToJson(
  AddWorkoutWeightRequest instance,
) => <String, dynamic>{'weight': instance.weight};
