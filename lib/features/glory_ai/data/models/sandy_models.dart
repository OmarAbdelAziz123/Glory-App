import 'package:json_annotation/json_annotation.dart';

part 'sandy_models.g.dart';

Object? _readConversationMessageCount(Map<dynamic, dynamic> json, String key) {
  final direct = json['messageCount'];
  if (direct != null) return direct;

  final count = json['_count'];
  if (count is Map) {
    final messages = count['messages'];
    if (messages != null) return messages;
  }

  return 0;
}

@JsonSerializable()
final class SandyChatRequest {
  const SandyChatRequest({
    required this.message,
    this.conversationId,
  });

  factory SandyChatRequest.fromJson(Map<String, dynamic> json) =>
      _$SandyChatRequestFromJson(json);

  final String message;

  @JsonKey(includeIfNull: false)
  final String? conversationId;

  Map<String, dynamic> toJson() => _$SandyChatRequestToJson(this);
}

@JsonSerializable()
final class SandyCitationModel {
  const SandyCitationModel({
    required this.docId,
    required this.title,
    required this.sourceName,
    required this.sourceUrl,
  });

  factory SandyCitationModel.fromJson(Map<String, dynamic> json) =>
      _$SandyCitationModelFromJson(json);

  final String docId;
  final String title;
  final String sourceName;
  final String sourceUrl;
}

@JsonSerializable()
final class SandyChatMetaModel {
  const SandyChatMetaModel({
    this.model,
    this.latencyMs,
    this.retrievedChunks,
  });

  factory SandyChatMetaModel.fromJson(Map<String, dynamic> json) =>
      _$SandyChatMetaModelFromJson(json);

  final String? model;
  final int? latencyMs;
  final int? retrievedChunks;
}

@JsonSerializable()
final class SandyChatResponseModel {
  const SandyChatResponseModel({
    required this.conversationId,
    required this.messageId,
    required this.answer,
    required this.citations,
    this.refusalReason,
    this.meta,
  });

  factory SandyChatResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SandyChatResponseModelFromJson(json);

  final String conversationId;
  final String messageId;
  final String answer;
  final List<SandyCitationModel> citations;
  final String? refusalReason;
  final SandyChatMetaModel? meta;
}

@JsonSerializable()
final class SandyConversationModel {
  const SandyConversationModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.lastMessageAt,
    required this.messageCount,
    this.lastMessage,
  });

  factory SandyConversationModel.fromJson(Map<String, dynamic> json) =>
      _$SandyConversationModelFromJson(json);

  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime lastMessageAt;

  @JsonKey(readValue: _readConversationMessageCount, defaultValue: 0)
  final int messageCount;

  final SandyConversationPreviewModel? lastMessage;
}

@JsonSerializable()
final class SandyConversationPreviewModel {
  const SandyConversationPreviewModel({
    required this.body,
    required this.senderType,
    required this.createdAt,
  });

  factory SandyConversationPreviewModel.fromJson(Map<String, dynamic> json) =>
      _$SandyConversationPreviewModelFromJson(json);

  final String body;
  final String senderType;
  final DateTime createdAt;
}

@JsonSerializable()
final class SandyMessageModel {
  const SandyMessageModel({
    required this.id,
    required this.body,
    required this.senderType,
    required this.createdAt,
    this.citations,
    this.refusalReason,
  });

  factory SandyMessageModel.fromJson(Map<String, dynamic> json) =>
      _$SandyMessageModelFromJson(json);

  final String id;
  final String body;
  final String senderType;
  final DateTime createdAt;
  final List<SandyCitationModel>? citations;
  final String? refusalReason;
}

@JsonSerializable()
final class SandyRenameConversationRequest {
  const SandyRenameConversationRequest({required this.title});

  factory SandyRenameConversationRequest.fromJson(Map<String, dynamic> json) =>
      _$SandyRenameConversationRequestFromJson(json);

  final String title;

  Map<String, dynamic> toJson() => _$SandyRenameConversationRequestToJson(this);
}
