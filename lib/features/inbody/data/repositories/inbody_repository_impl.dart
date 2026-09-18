import '../../../../core/result/result.dart';
import '../../domain/entities/inbody_entities.dart';
import '../../domain/repositories/inbody_repository.dart';
import '../datasources/inbody_remote_api_service.dart';

final class InbodyRepositoryImpl implements InbodyRepository {
  const InbodyRepositoryImpl(this._remote);

  final InbodyRemoteApiService _remote;

  @override
  Future<Result<InbodySummaryEntity>> getSummary() => _remote.getSummary();

  @override
  Future<Result<InbodyTrendsEntity>> getTrends({int limit = 12}) =>
      _remote.getTrends(limit: limit);

  @override
  Future<Result<InbodyPageEntity>> getTests({
    int page = 1,
    int limit = 20,
    InbodySource? source,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) =>
      _remote.getTests(
        page: page,
        limit: limit,
        source: source,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );

  @override
  Future<Result<InbodyTestEntity>> getTest(String id) => _remote.getTest(id);
}
