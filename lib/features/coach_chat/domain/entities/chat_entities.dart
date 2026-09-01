enum ChatSenderType { member, instructor }

final class ChatParticipantEntity {
  const ChatParticipantEntity({
    required this.id,
    required this.fullName,
    this.avatarUrl,
  });

  final String id;
  final String fullName;
  final String? avatarUrl;
}

final class ChatConversationEntity {
  const ChatConversationEntity({
    required this.id,
    required this.memberId,
    required this.instructorId,
    required this.createdAt,
    this.lastMessageAt,
    required this.instructor,
    required this.unreadCount,
  });

  final String id;
  final String memberId;
  final String instructorId;
  final DateTime createdAt;
  final DateTime? lastMessageAt;
  final ChatParticipantEntity instructor;
  final int unreadCount;
}

final class ChatMessageEntity {
  const ChatMessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderType,
    required this.sender,
    required this.body,
    required this.read,
    this.readAt,
    required this.createdAt,
    this.isPending = false,
  });

  final String id;
  final String conversationId;
  final ChatSenderType senderType;
  final ChatParticipantEntity sender;
  final String body;
  final bool read;
  final DateTime? readAt;
  final DateTime createdAt;
  final bool isPending;

  bool get isMember => senderType == ChatSenderType.member;

  ChatMessageEntity copyWith({
    String? id,
    String? conversationId,
    ChatSenderType? senderType,
    ChatParticipantEntity? sender,
    String? body,
    bool? read,
    DateTime? readAt,
    DateTime? createdAt,
    bool? isPending,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderType: senderType ?? this.senderType,
      sender: sender ?? this.sender,
      body: body ?? this.body,
      read: read ?? this.read,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      isPending: isPending ?? this.isPending,
    );
  }
}

final class ChatMessagesPageEntity {
  const ChatMessagesPageEntity({
    required this.items,
    required this.page,
    required this.totalPages,
  });

  final List<ChatMessageEntity> items;
  final int page;
  final int totalPages;

  bool get hasMore => page < totalPages;
}
