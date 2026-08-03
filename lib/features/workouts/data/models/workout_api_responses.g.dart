// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_api_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutAssignmentsApiResponse _$WorkoutAssignmentsApiResponseFromJson(
  Map<String, dynamic> json,
) => WorkoutAssignmentsApiResponse(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>?)
      ?.map(
        (e) => WorkoutAssignmentListModel.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  meta: json['meta'] == null
      ? null
      : PaginationMetaModel.fromJson(json['meta'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$WorkoutAssignmentsApiResponseToJson(
  WorkoutAssignmentsApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'meta': instance.meta,
  'message': instance.message,
};

WorkoutAssignmentApiResponse _$WorkoutAssignmentApiResponseFromJson(
  Map<String, dynamic> json,
) => WorkoutAssignmentApiResponse(
  success: json['success'] as bool,
  data: json['data'] == null
      ? null
      : WorkoutAssignmentDetailModel.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
  message: json['message'] as String?,
);

Map<String, dynamic> _$WorkoutAssignmentApiResponseToJson(
  WorkoutAssignmentApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

WorkoutVideosApiResponse _$WorkoutVideosApiResponseFromJson(
  Map<String, dynamic> json,
) => WorkoutVideosApiResponse(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => WorkoutVideoModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  message: json['message'] as String?,
);

Map<String, dynamic> _$WorkoutVideosApiResponseToJson(
  WorkoutVideosApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};
