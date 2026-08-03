import '../../../../core/result/result.dart';
import '../../domain/entities/content_entities.dart';
import '../../domain/repositories/content_repository.dart';
import '../datasources/content_remote_api_service.dart';
import '../mappers/content_mappers.dart';
import '../models/feedback_request.dart';

final class ContentRepositoryImpl implements ContentRepository {
  const ContentRepositoryImpl(this._remote);

  final ContentRemoteApiService _remote;

  @override
  Future<Result<List<InfoPageEntity>>> getInfoPages() async {
    final result = await _remote.getInfoPages();

    return switch (result) {
      Success(:final data) =>
        Success(data.map((page) => page.toEntity()).toList()),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<InfoPageEntity>> getInfoPageByKey(String key) async {
    final result = await _remote.getInfoPageByKey(key);

    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<List<FaqEntity>>> getFaqs() async {
    final result = await _remote.getFaqs();

    return switch (result) {
      Success(:final data) => Success(
          data.map((faq) => faq.toEntity()).toList()
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)),
        ),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<ContactLinksEntity>> getContactLinks() async {
    final result = await _remote.getContactLinks();

    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<void>> submitFeedback({required String message}) async {
    final result = await _remote.submitFeedback(FeedbackRequest(message: message));

    return switch (result) {
      Success() => const Success(null),
      Failure(:final failure) => Failure(failure),
    };
  }
}
