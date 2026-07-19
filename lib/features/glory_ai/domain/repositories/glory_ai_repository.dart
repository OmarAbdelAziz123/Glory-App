import '../../../../core/result/result.dart';
import '../entities/ai_message_entity.dart';

abstract interface class GloryAiRepository {
  Future<Result<AiMessageEntity>> sendMessage(String message);

  Future<Result<List<AiMessageEntity>>> getChatHistory();

  Future<Result<void>> clearHistory();
}
