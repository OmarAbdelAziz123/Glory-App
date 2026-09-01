import 'package:json_annotation/json_annotation.dart';

import '../../../../core/network/models/pagination_meta_model.dart';
import 'chat_models.dart';

part 'chat_api_responses.g.dart';

@JsonSerializable()
final class ChatConversationsApiResponse {
  const ChatConversationsApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory ChatConversationsApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatConversationsApiResponseFromJson(json);

  final bool success;
  final List<ChatConversationModel>? data;
  final String? message;
}

@JsonSerializable()
final class ChatMessagesApiResponse {
  const ChatMessagesApiResponse({
    required this.success,
    this.data,
    this.meta,
    this.message,
  });

  factory ChatMessagesApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatMessagesApiResponseFromJson(json);

  final bool success;
  final List<ChatMessageModel>? data;
  final PaginationMetaModel? meta;
  final String? message;
}

@JsonSerializable()
final class ChatUnreadCountApiResponse {
  const ChatUnreadCountApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory ChatUnreadCountApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatUnreadCountApiResponseFromJson(json);

  final bool success;
  final ChatUnreadCountModel? data;
  final String? message;
}

@JsonSerializable()
final class ChatMarkReadApiResponse {
  const ChatMarkReadApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory ChatMarkReadApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatMarkReadApiResponseFromJson(json);

  final bool success;
  final ChatMarkReadModel? data;
  final String? message;
}
