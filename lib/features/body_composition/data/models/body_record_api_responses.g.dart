// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_record_api_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BodyRecordsApiResponse _$BodyRecordsApiResponseFromJson(
  Map<String, dynamic> json,
) => BodyRecordsApiResponse(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => BodyRecordModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: json['meta'] == null
      ? null
      : PaginationMetaModel.fromJson(json['meta'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$BodyRecordsApiResponseToJson(
  BodyRecordsApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'meta': instance.meta,
  'message': instance.message,
};
