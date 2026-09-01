import '../../../../core/result/result.dart';
import '../entities/chat_entities.dart';

abstract interface class CoachChatRepository {
  Future<Result<List<ChatConversationEntity>>> getConversations();

  Future<Result<ChatMessagesPageEntity>> getMessages({
    required String conversationId,
    int page = 1,
    int limit = 30,
  });

  Future<Result<int>> markConversationAsRead(String conversationId);

  Future<Result<int>> getUnreadCount();

  void sendMessage({
    required String conversationId,
    required String body,
  });

  Stream<ChatMessageEntity> watchIncomingMessages();
}
