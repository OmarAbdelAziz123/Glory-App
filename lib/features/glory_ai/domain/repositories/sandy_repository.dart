import '../../../../core/result/result.dart';
import '../entities/sandy_entities.dart';

abstract interface class SandyRepository {
  Future<Result<SandyChatResultEntity>> sendMessage({
    required String message,
    String? conversationId,
  });

  Future<Result<SandyChatResultEntity>> streamMessage({
    required String message,
    String? conversationId,
    required void Function(String text) onDelta,
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

  Future<Result<SandyDocumentAnalyzeResultEntity>> analyzeDocument({
    required String filePath,
    String? note,
    String? conversationId,
    String? lang,
  });

  Future<Result<SandyDocumentsPageEntity>> getDocuments({
    int page = 1,
    int limit = 20,
  });

  Future<Result<SandyMedicalDocumentEntity>> getDocument(String documentId);

  Future<Result<void>> deleteDocument(String documentId);
}
