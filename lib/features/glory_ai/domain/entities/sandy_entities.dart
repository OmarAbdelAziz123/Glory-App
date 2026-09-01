enum SandyMessageRole { user, assistant }

enum SandyRefusalReason {
  outOfScope,
  medicalAdvice,
  unsafe,
  providerError,
}

final class SandyCitationEntity {
  const SandyCitationEntity({
    required this.docId,
    required this.title,
    required this.sourceName,
    required this.sourceUrl,
  });

  final String docId;
  final String title;
  final String sourceName;
  final String sourceUrl;
}

final class SandyMessageEntity {
  const SandyMessageEntity({
    required this.id,
    required this.body,
    required this.role,
    required this.createdAt,
    this.citations = const [],
    this.refusalReason,
  });

  final String id;
  final String body;
  final SandyMessageRole role;
  final DateTime createdAt;
  final List<SandyCitationEntity> citations;
  final SandyRefusalReason? refusalReason;

  bool get isUser => role == SandyMessageRole.user;
}

final class SandyConversationPreviewEntity {
  const SandyConversationPreviewEntity({
    required this.body,
    required this.role,
    required this.createdAt,
  });

  final String body;
  final SandyMessageRole role;
  final DateTime createdAt;
}

final class SandyConversationEntity {
  const SandyConversationEntity({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.lastMessageAt,
    required this.messageCount,
    this.lastMessage,
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime lastMessageAt;
  final int messageCount;
  final SandyConversationPreviewEntity? lastMessage;

  SandyConversationEntity copyWith({
    String? title,
    SandyConversationPreviewEntity? lastMessage,
    DateTime? lastMessageAt,
    int? messageCount,
  }) {
    return SandyConversationEntity(
      id: id,
      title: title ?? this.title,
      createdAt: createdAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      messageCount: messageCount ?? this.messageCount,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }
}

final class SandyChatResultEntity {
  const SandyChatResultEntity({
    required this.conversationId,
    required this.message,
  });

  final String conversationId;
  final SandyMessageEntity message;
}

final class SandyMessagesPageEntity {
  const SandyMessagesPageEntity({
    required this.items,
    required this.page,
    required this.totalPages,
  });

  final List<SandyMessageEntity> items;
  final int page;
  final int totalPages;

  bool get hasMore => page < totalPages;
}
