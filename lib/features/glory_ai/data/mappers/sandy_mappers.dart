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
        refusalReason: mapSandyRefusal(refusalReason),
        attachmentUrl: fileUrl,
        attachmentIsImage: _isImageAttachment(fileUrl, fileType),
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
          refusalReason: mapSandyRefusal(refusalReason),
        ),
      );
}

SandyRefusalReason? mapSandyRefusal(String? value) => switch (value) {
      'OUT_OF_SCOPE' => SandyRefusalReason.outOfScope,
      'MEDICAL_ADVICE' => SandyRefusalReason.medicalAdvice,
      'UNSAFE' => SandyRefusalReason.unsafe,
      'PROVIDER_ERROR' => SandyRefusalReason.providerError,
      _ => null,
    };

SandyDocumentKind mapSandyDocumentKind(String? value) => switch (value) {
      'LAB_RESULT' => SandyDocumentKind.labResult,
      'IMAGING' => SandyDocumentKind.imaging,
      'REPORT' => SandyDocumentKind.report,
      'PRESCRIPTION' => SandyDocumentKind.prescription,
      _ => SandyDocumentKind.other,
    };

SandyFlagSeverity _mapFlagSeverity(String? value) => switch (value) {
      'high' => SandyFlagSeverity.high,
      'medium' => SandyFlagSeverity.medium,
      _ => SandyFlagSeverity.low,
    };

bool _isImageAttachment(String? url, String? fileType) {
  final type = (fileType ?? '').toLowerCase();
  final path = (url ?? '').toLowerCase();
  if (type.contains('pdf') || path.contains('.pdf')) return false;
  return type.contains('image') ||
      path.contains('.png') ||
      path.contains('.jpg') ||
      path.contains('.jpeg') ||
      path.contains('.webp') ||
      path.contains('.heic');
}

extension SandyMedicalFlagModelX on SandyMedicalFlagModel {
  SandyMedicalFlagEntity toEntity() => SandyMedicalFlagEntity(
        severity: _mapFlagSeverity(severity),
        area: area,
        note: note,
      );
}

extension SandyAnalyzeDocumentModelX on SandyAnalyzeDocumentModel {
  SandyDocumentAnalyzeResultEntity toEntity() =>
      SandyDocumentAnalyzeResultEntity(
        recordId: recordId,
        kind: mapSandyDocumentKind(kind),
        title: title,
        reply: reply,
        summary: summary,
        flags: flags?.map((flag) => flag.toEntity()).toList() ?? const [],
        trainingCaution: trainingCaution ?? false,
      );
}

extension SandyMedicalDocumentModelX on SandyMedicalDocumentModel {
  SandyMedicalDocumentEntity toEntity() => SandyMedicalDocumentEntity(
        id: id,
        kind: mapSandyDocumentKind(kind),
        title: title,
        fileUrl: fileUrl,
        fileType: fileType,
        summary: summary,
        flags: flags?.map((flag) => flag.toEntity()).toList() ?? const [],
        trainingCaution: trainingCaution ?? false,
        createdAt: createdAt,
      );
}
