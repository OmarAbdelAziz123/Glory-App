// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sandy_api_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SandyChatApiResponse _$SandyChatApiResponseFromJson(
  Map<String, dynamic> json,
) => SandyChatApiResponse(
  success: json['success'] as bool,
  data: json['data'] == null
      ? null
      : SandyChatResponseModel.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$SandyChatApiResponseToJson(
  SandyChatApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

SandySuggestionsApiResponse _$SandySuggestionsApiResponseFromJson(
  Map<String, dynamic> json,
) => SandySuggestionsApiResponse(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>?)?.map((e) => e as String).toList(),
  message: json['message'] as String?,
);

Map<String, dynamic> _$SandySuggestionsApiResponseToJson(
  SandySuggestionsApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

SandyConversationsApiResponse _$SandyConversationsApiResponseFromJson(
  Map<String, dynamic> json,
) => SandyConversationsApiResponse(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => SandyConversationModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  message: json['message'] as String?,
);

Map<String, dynamic> _$SandyConversationsApiResponseToJson(
  SandyConversationsApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

SandyMessagesApiResponse _$SandyMessagesApiResponseFromJson(
  Map<String, dynamic> json,
) => SandyMessagesApiResponse(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => SandyMessageModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: json['meta'] == null
      ? null
      : PaginationMetaModel.fromJson(json['meta'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$SandyMessagesApiResponseToJson(
  SandyMessagesApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'meta': instance.meta,
  'message': instance.message,
};

SandyVoidApiResponse _$SandyVoidApiResponseFromJson(
  Map<String, dynamic> json,
) => SandyVoidApiResponse(
  success: json['success'] as bool,
  message: json['message'] as String?,
);

Map<String, dynamic> _$SandyVoidApiResponseToJson(
  SandyVoidApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
};
