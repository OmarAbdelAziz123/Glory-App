// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_api_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InfoPageApiResponse _$InfoPageApiResponseFromJson(Map<String, dynamic> json) =>
    InfoPageApiResponse(
      success: json['success'] as bool,
      data: json['data'] == null
          ? null
          : InfoPageModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$InfoPageApiResponseToJson(
  InfoPageApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

InfoPagesApiResponse _$InfoPagesApiResponseFromJson(
  Map<String, dynamic> json,
) => InfoPagesApiResponse(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => InfoPageModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  message: json['message'] as String?,
);

Map<String, dynamic> _$InfoPagesApiResponseToJson(
  InfoPagesApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

FaqsApiResponse _$FaqsApiResponseFromJson(Map<String, dynamic> json) =>
    FaqsApiResponse(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => FaqModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$FaqsApiResponseToJson(FaqsApiResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'message': instance.message,
    };

ContactApiResponse _$ContactApiResponseFromJson(Map<String, dynamic> json) =>
    ContactApiResponse(
      success: json['success'] as bool,
      data: json['data'] == null
          ? null
          : ContactLinksModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ContactApiResponseToJson(ContactApiResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'message': instance.message,
    };

FeedbackApiResponse _$FeedbackApiResponseFromJson(Map<String, dynamic> json) =>
    FeedbackApiResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$FeedbackApiResponseToJson(
  FeedbackApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
};
