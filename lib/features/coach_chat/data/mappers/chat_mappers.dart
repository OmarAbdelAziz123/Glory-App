import '../../domain/entities/chat_entities.dart';
import '../models/chat_api_responses.dart';
import '../models/chat_models.dart';

extension ChatParticipantModelMapper on ChatParticipantModel {
  ChatParticipantEntity toEntity() => ChatParticipantEntity(
        id: id,
        fullName: fullName,
        avatarUrl: avatarUrl,
      );
}

extension ChatConversationModelMapper on ChatConversationModel {
  ChatConversationEntity toEntity() => ChatConversationEntity(
        id: id,
        memberId: memberId,
        instructorId: instructorId,
        createdAt: createdAt,
        lastMessageAt: lastMessageAt,
        instructor: instructor.toEntity(),
        unreadCount: unreadCount,
      );
}

ChatSenderType _parseSenderType(String value) => switch (value.toUpperCase()) {
      'MEMBER' => ChatSenderType.member,
      _ => ChatSenderType.instructor,
    };

extension ChatMessageModelMapper on ChatMessageModel {
  ChatMessageEntity toEntity({bool isPending = false}) => ChatMessageEntity(
        id: id,
        conversationId: conversationId,
        senderType: _parseSenderType(senderType),
        sender: sender.toEntity(),
        body: body,
        read: read,
        readAt: readAt,
        createdAt: createdAt,
        isPending: isPending,
      );
}

extension ChatMessagesApiResponseMapper on ChatMessagesApiResponse {
  ChatMessagesPageEntity? toPageEntity() {
    final messages = data;
    final pagination = meta;
    if (messages == null || pagination == null) return null;

    return ChatMessagesPageEntity(
      items: messages.map((m) => m.toEntity()).toList(),
      page: pagination.page,
      totalPages: pagination.totalPages,
    );
  }
}

extension ChatConversationsApiResponseMapper on ChatConversationsApiResponse {
  List<ChatConversationEntity>? toEntities() =>
      data?.map((item) => item.toEntity()).toList();
}
