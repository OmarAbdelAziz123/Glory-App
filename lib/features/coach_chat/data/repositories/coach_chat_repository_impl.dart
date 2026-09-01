import '../../../../core/error/app_failure.dart';
import '../../../../core/l10n/fallback_messages.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/chat_entities.dart';
import '../../domain/repositories/coach_chat_repository.dart';
import '../datasources/coach_chat_remote_api_service.dart';
import '../datasources/coach_chat_socket_service.dart';
import '../mappers/chat_mappers.dart';
import '../models/chat_api_responses.dart';

final class CoachChatRepositoryImpl implements CoachChatRepository {
  const CoachChatRepositoryImpl(this._remote, this._socket);

  final CoachChatRemoteApiService _remote;
  final CoachChatSocketService _socket;

  @override
  Future<Result<List<ChatConversationEntity>>> getConversations() async {
    final result = await _remote.getConversations();
    return switch (result) {
      Success(:final data) => _mapConversations(data),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<ChatMessagesPageEntity>> getMessages({
    required String conversationId,
    int page = 1,
    int limit = 30,
  }) async {
    final result = await _remote.getMessages(
      conversationId: conversationId,
      page: page,
      limit: limit,
    );

    return switch (result) {
      Success(:final data) => _mapMessagesPage(data),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<int>> markConversationAsRead(String conversationId) =>
      _remote.markAsRead(conversationId);

  @override
  Future<Result<int>> getUnreadCount() => _remote.getUnreadCount();

  @override
  void sendMessage({
    required String conversationId,
    required String body,
  }) {
    _socket.sendMessage(conversationId: conversationId, body: body);
  }

  @override
  Stream<ChatMessageEntity> watchIncomingMessages() =>
      _socket.onMessage.map((model) => model.toEntity());

  Result<List<ChatConversationEntity>> _mapConversations(
    ChatConversationsApiResponse data,
  ) {
    final entities = data.toEntities();
    if (entities == null) {
      return Failure(ServerFailure(FallbackMessages.errorTryAgain));
    }
    return Success(entities);
  }

  Result<ChatMessagesPageEntity> _mapMessagesPage(
    ChatMessagesApiResponse data,
  ) {
    final pageEntity = data.toPageEntity();
    if (pageEntity == null) {
      return Failure(ServerFailure(FallbackMessages.errorTryAgain));
    }
    return Success(pageEntity);
  }
}
