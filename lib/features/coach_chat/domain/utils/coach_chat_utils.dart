import '../entities/chat_entities.dart';

abstract final class CoachChatUtils {
  static ChatConversationEntity? findPtConversation(
    List<ChatConversationEntity> conversations,
  ) {
    for (final conversation in conversations) {
      if (conversation.coachTypes.contains('PT')) {
        return conversation;
      }
    }
    return null;
  }
}
