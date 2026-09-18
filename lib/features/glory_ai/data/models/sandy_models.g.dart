// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sandy_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SandyChatRequest _$SandyChatRequestFromJson(Map<String, dynamic> json) =>
    SandyChatRequest(
      message: json['message'] as String,
      conversationId: json['conversationId'] as String?,
    );

Map<String, dynamic> _$SandyChatRequestToJson(SandyChatRequest instance) =>
    <String, dynamic>{
      'message': instance.message,
      'conversationId': ?instance.conversationId,
    };

SandyCitationModel _$SandyCitationModelFromJson(Map<String, dynamic> json) =>
    SandyCitationModel(
      docId: json['docId'] as String,
      title: json['title'] as String,
      sourceName: json['sourceName'] as String,
      sourceUrl: json['sourceUrl'] as String,
    );

Map<String, dynamic> _$SandyCitationModelToJson(SandyCitationModel instance) =>
    <String, dynamic>{
      'docId': instance.docId,
      'title': instance.title,
      'sourceName': instance.sourceName,
      'sourceUrl': instance.sourceUrl,
    };

SandyChatMetaModel _$SandyChatMetaModelFromJson(Map<String, dynamic> json) =>
    SandyChatMetaModel(
      model: json['model'] as String?,
      latencyMs: (json['latencyMs'] as num?)?.toInt(),
      retrievedChunks: (json['retrievedChunks'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SandyChatMetaModelToJson(SandyChatMetaModel instance) =>
    <String, dynamic>{
      'model': instance.model,
      'latencyMs': instance.latencyMs,
      'retrievedChunks': instance.retrievedChunks,
    };

SandyChatResponseModel _$SandyChatResponseModelFromJson(
  Map<String, dynamic> json,
) => SandyChatResponseModel(
  conversationId: json['conversationId'] as String,
  messageId: json['messageId'] as String,
  answer: json['answer'] as String,
  citations: (json['citations'] as List<dynamic>)
      .map((e) => SandyCitationModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  refusalReason: json['refusalReason'] as String?,
  meta: json['meta'] == null
      ? null
      : SandyChatMetaModel.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SandyChatResponseModelToJson(
  SandyChatResponseModel instance,
) => <String, dynamic>{
  'conversationId': instance.conversationId,
  'messageId': instance.messageId,
  'answer': instance.answer,
  'citations': instance.citations,
  'refusalReason': instance.refusalReason,
  'meta': instance.meta,
};

SandyConversationModel _$SandyConversationModelFromJson(
  Map<String, dynamic> json,
) => SandyConversationModel(
  id: json['id'] as String,
  title: json['title'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  lastMessageAt: DateTime.parse(json['lastMessageAt'] as String),
  messageCount:
      (_readConversationMessageCount(json, 'messageCount') as num?)?.toInt() ??
      0,
  lastMessage: json['lastMessage'] == null
      ? null
      : SandyConversationPreviewModel.fromJson(
          json['lastMessage'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$SandyConversationModelToJson(
  SandyConversationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'createdAt': instance.createdAt.toIso8601String(),
  'lastMessageAt': instance.lastMessageAt.toIso8601String(),
  'messageCount': instance.messageCount,
  'lastMessage': instance.lastMessage,
};

SandyConversationPreviewModel _$SandyConversationPreviewModelFromJson(
  Map<String, dynamic> json,
) => SandyConversationPreviewModel(
  body: json['body'] as String,
  senderType: json['senderType'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$SandyConversationPreviewModelToJson(
  SandyConversationPreviewModel instance,
) => <String, dynamic>{
  'body': instance.body,
  'senderType': instance.senderType,
  'createdAt': instance.createdAt.toIso8601String(),
};

SandyMessageModel _$SandyMessageModelFromJson(Map<String, dynamic> json) =>
    SandyMessageModel(
      id: json['id'] as String,
      body: json['body'] as String,
      senderType: json['senderType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      citations: (json['citations'] as List<dynamic>?)
          ?.map((e) => SandyCitationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      refusalReason: json['refusalReason'] as String?,
      fileUrl: json['fileUrl'] as String?,
      fileType: json['fileType'] as String?,
    );

Map<String, dynamic> _$SandyMessageModelToJson(SandyMessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      'senderType': instance.senderType,
      'createdAt': instance.createdAt.toIso8601String(),
      'citations': instance.citations,
      'refusalReason': instance.refusalReason,
      'fileUrl': instance.fileUrl,
      'fileType': instance.fileType,
    };

SandyRenameConversationRequest _$SandyRenameConversationRequestFromJson(
  Map<String, dynamic> json,
) => SandyRenameConversationRequest(title: json['title'] as String);

Map<String, dynamic> _$SandyRenameConversationRequestToJson(
  SandyRenameConversationRequest instance,
) => <String, dynamic>{'title': instance.title};

Map<String, dynamic> _$SandyAnalyzeDocumentRequestToJson(
  SandyAnalyzeDocumentRequest instance,
) => <String, dynamic>{
  'fileUrl': instance.fileUrl,
  'note': ?instance.note,
  'conversationId': ?instance.conversationId,
  'lang': ?instance.lang,
};

SandyMedicalFlagModel _$SandyMedicalFlagModelFromJson(
  Map<String, dynamic> json,
) => SandyMedicalFlagModel(
  severity: json['severity'] as String,
  note: json['note'] as String,
  area: json['area'] as String?,
);

Map<String, dynamic> _$SandyMedicalFlagModelToJson(
  SandyMedicalFlagModel instance,
) => <String, dynamic>{
  'severity': instance.severity,
  'area': instance.area,
  'note': instance.note,
};

SandyAnalyzeDocumentModel _$SandyAnalyzeDocumentModelFromJson(
  Map<String, dynamic> json,
) => SandyAnalyzeDocumentModel(
  recordId: json['recordId'] as String,
  kind: json['kind'] as String,
  title: json['title'] as String,
  reply: json['reply'] as String,
  summary: json['summary'] as String,
  flags: (json['flags'] as List<dynamic>?)
      ?.map((e) => SandyMedicalFlagModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  trainingCaution: json['trainingCaution'] as bool?,
  meta: json['meta'] == null
      ? null
      : SandyChatMetaModel.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SandyAnalyzeDocumentModelToJson(
  SandyAnalyzeDocumentModel instance,
) => <String, dynamic>{
  'recordId': instance.recordId,
  'kind': instance.kind,
  'title': instance.title,
  'reply': instance.reply,
  'summary': instance.summary,
  'flags': instance.flags,
  'trainingCaution': instance.trainingCaution,
  'meta': instance.meta,
};

SandyMedicalDocumentModel _$SandyMedicalDocumentModelFromJson(
  Map<String, dynamic> json,
) => SandyMedicalDocumentModel(
  id: json['id'] as String,
  kind: json['kind'] as String,
  title: json['title'] as String,
  fileUrl: json['fileUrl'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  fileType: json['fileType'] as String?,
  summary: json['summary'] as String?,
  extracted: _extractedToString(json['extracted']),
  flags: (json['flags'] as List<dynamic>?)
      ?.map((e) => SandyMedicalFlagModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  trainingCaution: json['trainingCaution'] as bool?,
);

Map<String, dynamic> _$SandyMedicalDocumentModelToJson(
  SandyMedicalDocumentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'kind': instance.kind,
  'title': instance.title,
  'fileUrl': instance.fileUrl,
  'fileType': instance.fileType,
  'summary': instance.summary,
  'extracted': instance.extracted,
  'flags': instance.flags,
  'trainingCaution': instance.trainingCaution,
  'createdAt': instance.createdAt.toIso8601String(),
};
