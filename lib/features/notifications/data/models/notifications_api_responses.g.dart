// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_api_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationsApiResponse _$NotificationsApiResponseFromJson(
  Map<String, dynamic> json,
) => NotificationsApiResponse(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: json['meta'] == null
      ? null
      : PaginationMetaModel.fromJson(json['meta'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$NotificationsApiResponseToJson(
  NotificationsApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'meta': instance.meta,
  'message': instance.message,
};

NotificationApiResponse _$NotificationApiResponseFromJson(
  Map<String, dynamic> json,
) => NotificationApiResponse(
  success: json['success'] as bool,
  data: json['data'] == null
      ? null
      : NotificationModel.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$NotificationApiResponseToJson(
  NotificationApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

UnreadCountApiResponse _$UnreadCountApiResponseFromJson(
  Map<String, dynamic> json,
) => UnreadCountApiResponse(
  success: json['success'] as bool,
  data: json['data'] == null
      ? null
      : UnreadCountModel.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$UnreadCountApiResponseToJson(
  UnreadCountApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

ReadAllApiResponse _$ReadAllApiResponseFromJson(Map<String, dynamic> json) =>
    ReadAllApiResponse(
      success: json['success'] as bool,
      data: json['data'] == null
          ? null
          : ReadAllModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ReadAllApiResponseToJson(ReadAllApiResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'message': instance.message,
    };
