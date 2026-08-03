import '../../../../core/result/result.dart';
import '../entities/content_entities.dart';

abstract interface class ContentRepository {
  Future<Result<List<InfoPageEntity>>> getInfoPages();

  Future<Result<InfoPageEntity>> getInfoPageByKey(String key);

  Future<Result<List<FaqEntity>>> getFaqs();

  Future<Result<ContactLinksEntity>> getContactLinks();

  Future<Result<void>> submitFeedback({required String message});
}
