// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkin_api_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QrGenerateApiResponse _$QrGenerateApiResponseFromJson(
  Map<String, dynamic> json,
) => QrGenerateApiResponse(
  success: json['success'] as bool,
  data: json['data'] == null
      ? null
      : QrGenerateModel.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$QrGenerateApiResponseToJson(
  QrGenerateApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

QrStatusApiResponse _$QrStatusApiResponseFromJson(Map<String, dynamic> json) =>
    QrStatusApiResponse(
      success: json['success'] as bool,
      data: json['data'] == null
          ? null
          : QrStatusModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$QrStatusApiResponseToJson(
  QrStatusApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};
