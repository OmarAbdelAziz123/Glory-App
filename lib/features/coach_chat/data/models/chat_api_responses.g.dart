// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_api_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatConversationsApiResponse _$ChatConversationsApiResponseFromJson(
  Map<String, dynamic> json,
) => ChatConversationsApiResponse(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => ChatConversationModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  message: json['message'] as String?,
);

Map<String, dynamic> _$ChatConversationsApiResponseToJson(
  ChatConversationsApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

ChatMessagesApiResponse _$ChatMessagesApiResponseFromJson(
  Map<String, dynamic> json,
) => ChatMessagesApiResponse(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: json['meta'] == null
      ? null
      : PaginationMetaModel.fromJson(json['meta'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$ChatMessagesApiResponseToJson(
  ChatMessagesApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'meta': instance.meta,
  'message': instance.message,
};

ChatUnreadCountApiResponse _$ChatUnreadCountApiResponseFromJson(
  Map<String, dynamic> json,
) => ChatUnreadCountApiResponse(
  success: json['success'] as bool,
  data: json['data'] == null
      ? null
      : ChatUnreadCountModel.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$ChatUnreadCountApiResponseToJson(
  ChatUnreadCountApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

ChatMarkReadApiResponse _$ChatMarkReadApiResponseFromJson(
  Map<String, dynamic> json,
) => ChatMarkReadApiResponse(
  success: json['success'] as bool,
  data: json['data'] == null
      ? null
      : ChatMarkReadModel.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$ChatMarkReadApiResponseToJson(
  ChatMarkReadApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};
