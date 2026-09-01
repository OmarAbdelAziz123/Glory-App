import '../../../../core/result/result.dart';
import '../../domain/entities/sandy_entities.dart';
import '../../domain/repositories/sandy_repository.dart';
import '../datasources/sandy_remote_api_service.dart';
import '../mappers/sandy_mappers.dart';

final class SandyRepositoryImpl implements SandyRepository {
  const SandyRepositoryImpl(this._remote);

  final SandyRemoteApiService _remote;

  @override
  Future<Result<SandyChatResultEntity>> sendMessage({
    required String message,
    String? conversationId,
  }) async {
    final result = await _remote.sendMessage(
      message: message,
      conversationId: conversationId,
    );
    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<List<String>>> getSuggestions({required String lang}) async {
    return _remote.getSuggestions(lang: lang);
  }

  @override
  Future<Result<List<SandyConversationEntity>>> getConversations() async {
    final result = await _remote.getConversations();
    return switch (result) {
      Success(:final data) => Success(data.map((e) => e.toEntity()).toList()),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<SandyMessagesPageEntity>> getMessages({
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
      Success(:final data) => Success(
          SandyMessagesPageEntity(
            items: data.data!.map((e) => e.toEntity()).toList(),
            page: data.meta?.page ?? page,
            totalPages: data.meta?.totalPages ?? page,
          ),
        ),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<void>> renameConversation({
    required String conversationId,
    required String title,
  }) =>
      _remote.renameConversation(
        conversationId: conversationId,
        title: title,
      );

  @override
  Future<Result<void>> deleteConversation(String conversationId) =>
      _remote.deleteConversation(conversationId);
}
