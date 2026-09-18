import '../../../../core/result/result.dart';
import '../entities/inbody_entities.dart';

abstract interface class InbodyRepository {
  Future<Result<InbodySummaryEntity>> getSummary();

  Future<Result<InbodyTrendsEntity>> getTrends({int limit = 12});

  Future<Result<InbodyPageEntity>> getTests({
    int page = 1,
    int limit = 20,
    InbodySource? source,
    DateTime? dateFrom,
    DateTime? dateTo,
  });

  Future<Result<InbodyTestEntity>> getTest(String id);
}
