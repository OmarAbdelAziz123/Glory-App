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
    this.fileUrl,
    this.fileType,
  });

  factory SandyMessageModel.fromJson(Map<String, dynamic> json) =>
      _$SandyMessageModelFromJson(json);

  final String id;
  final String body;
  final String senderType;
  final DateTime createdAt;
  final List<SandyCitationModel>? citations;
  final String? refusalReason;
  final String? fileUrl;
  final String? fileType;
}

@JsonSerializable()
final class SandyRenameConversationRequest {
  const SandyRenameConversationRequest({required this.title});

  factory SandyRenameConversationRequest.fromJson(Map<String, dynamic> json) =>
      _$SandyRenameConversationRequestFromJson(json);

  final String title;

  Map<String, dynamic> toJson() => _$SandyRenameConversationRequestToJson(this);
}

@JsonSerializable(createFactory: false, includeIfNull: false)
final class SandyAnalyzeDocumentRequest {
  const SandyAnalyzeDocumentRequest({
    required this.fileUrl,
    this.note,
    this.conversationId,
    this.lang,
  });

  final String fileUrl;
  final String? note;
  final String? conversationId;
  final String? lang;

  Map<String, dynamic> toJson() => _$SandyAnalyzeDocumentRequestToJson(this);
}

@JsonSerializable()
final class SandyMedicalFlagModel {
  const SandyMedicalFlagModel({
    required this.severity,
    required this.note,
    this.area,
  });

  factory SandyMedicalFlagModel.fromJson(Map<String, dynamic> json) =>
      _$SandyMedicalFlagModelFromJson(json);

  final String severity;
  final String? area;
  final String note;
}

@JsonSerializable()
final class SandyAnalyzeDocumentModel {
  const SandyAnalyzeDocumentModel({
    required this.recordId,
    required this.kind,
    required this.title,
    required this.reply,
    required this.summary,
    this.flags,
    this.trainingCaution,
    this.meta,
  });

  factory SandyAnalyzeDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$SandyAnalyzeDocumentModelFromJson(json);

  final String recordId;
  final String kind;
  final String title;
  final String reply;
  final String summary;
  final List<SandyMedicalFlagModel>? flags;
  final bool? trainingCaution;
  final SandyChatMetaModel? meta;
}

@JsonSerializable()
final class SandyMedicalDocumentModel {
  const SandyMedicalDocumentModel({
    required this.id,
    required this.kind,
    required this.title,
    required this.fileUrl,
    required this.createdAt,
    this.fileType,
    this.summary,
    this.extracted,
    this.flags,
    this.trainingCaution,
  });

  factory SandyMedicalDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$SandyMedicalDocumentModelFromJson(json);

  final String id;
  final String kind;
  final String title;
  final String fileUrl;
  final String? fileType;
  final String? summary;
  @JsonKey(fromJson: _extractedToString)
  final String? extracted;
  final List<SandyMedicalFlagModel>? flags;
  final bool? trainingCaution;
  final DateTime createdAt;
}

String? _extractedToString(Object? value) {
  if (value == null) return null;
  if (value is String) return value;
  return value.toString();
}
