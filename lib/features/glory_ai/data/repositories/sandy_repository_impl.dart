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
  Future<Result<SandyChatResultEntity>> streamMessage({
    required String message,
    String? conversationId,
    required void Function(String text) onDelta,
  }) async {
    final result = await _remote.streamMessage(
      message: message,
      conversationId: conversationId,
      onDelta: onDelta,
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

  @override
  Future<Result<SandyDocumentAnalyzeResultEntity>> analyzeDocument({
    required String filePath,
    String? note,
    String? conversationId,
    String? lang,
  }) async {
    final upload = await _remote.uploadFile(filePath);
    switch (upload) {
      case Failure(:final failure):
        return Failure(failure);
      case Success(data: final fileUrl):
        final result = await _remote.analyzeDocument(
          fileUrl: fileUrl,
          note: note,
          conversationId: conversationId,
          lang: lang,
        );
        return switch (result) {
          Success(:final data) => Success(data.toEntity()),
          Failure(:final failure) => Failure(failure),
        };
    }
  }

  @override
  Future<Result<SandyDocumentsPageEntity>> getDocuments({
    int page = 1,
    int limit = 20,
  }) async {
    final result = await _remote.getDocuments(page: page, limit: limit);
    return switch (result) {
      Success(:final data) => Success(
          SandyDocumentsPageEntity(
            items: data.data?.map((e) => e.toEntity()).toList() ?? const [],
            page: data.meta?.page ?? page,
            totalPages: data.meta?.totalPages ?? page,
          ),
        ),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<SandyMedicalDocumentEntity>> getDocument(
    String documentId,
  ) async {
    final result = await _remote.getDocument(documentId);
    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<void>> deleteDocument(String documentId) =>
      _remote.deleteDocument(documentId);
}
