import '../../domain/entities/sandy_entities.dart';
import '../models/sandy_models.dart';

extension SandyCitationModelX on SandyCitationModel {
  SandyCitationEntity toEntity() => SandyCitationEntity(
        docId: docId,
        title: title,
        sourceName: sourceName,
        sourceUrl: sourceUrl,
      );
}

extension SandyMessageModelX on SandyMessageModel {
  SandyMessageEntity toEntity() => SandyMessageEntity(
        id: id,
        body: body,
        role: senderType == 'MEMBER'
            ? SandyMessageRole.user
            : SandyMessageRole.assistant,
        createdAt: createdAt,
        citations: citations?.map((e) => e.toEntity()).toList() ?? const [],
        refusalReason: _mapRefusal(refusalReason),
      );
}

extension SandyConversationModelX on SandyConversationModel {
  SandyConversationEntity toEntity() => SandyConversationEntity(
        id: id,
        title: title,
        createdAt: createdAt,
        lastMessageAt: lastMessageAt,
        messageCount: messageCount,
        lastMessage: lastMessage == null
            ? null
            : SandyConversationPreviewEntity(
                body: lastMessage!.body,
                role: lastMessage!.senderType == 'MEMBER'
                    ? SandyMessageRole.user
                    : SandyMessageRole.assistant,
                createdAt: lastMessage!.createdAt,
              ),
      );
}

extension SandyChatResponseModelX on SandyChatResponseModel {
  SandyChatResultEntity toEntity() => SandyChatResultEntity(
        conversationId: conversationId,
        message: SandyMessageEntity(
          id: messageId,
          body: answer,
          role: SandyMessageRole.assistant,
          createdAt: DateTime.now(),
          citations: citations.map((e) => e.toEntity()).toList(),
          refusalReason: _mapRefusal(refusalReason),
        ),
      );
}

SandyRefusalReason? _mapRefusal(String? value) => switch (value) {
      'OUT_OF_SCOPE' => SandyRefusalReason.outOfScope,
      'MEDICAL_ADVICE' => SandyRefusalReason.medicalAdvice,
      'UNSAFE' => SandyRefusalReason.unsafe,
      'PROVIDER_ERROR' => SandyRefusalReason.providerError,
      _ => null,
    };
