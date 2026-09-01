import '../../../../core/result/result.dart';
import '../entities/sandy_entities.dart';

abstract interface class SandyRepository {
  Future<Result<SandyChatResultEntity>> sendMessage({
    required String message,
    String? conversationId,
  });

  Future<Result<List<String>>> getSuggestions({required String lang});

  Future<Result<List<SandyConversationEntity>>> getConversations();

  Future<Result<SandyMessagesPageEntity>> getMessages({
    required String conversationId,
    int page = 1,
    int limit = 30,
  });

  Future<Result<void>> renameConversation({
    required String conversationId,
    required String title,
  });

  Future<Result<void>> deleteConversation(String conversationId);
}
