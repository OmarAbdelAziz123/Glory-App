import '../../../../core/error/app_failure.dart';
import '../../../../core/l10n/fallback_messages.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/inbody_entities.dart';
import '../models/inbody_models.dart';

final class InbodyRemoteApiService extends ApiService {
  const InbodyRemoteApiService(super.dio);

  Future<Result<InbodySummaryEntity>> getSummary() => _read(
        Endpoints.mobileInbodySummary,
        parse: readInbodySummary,
      );

  Future<Result<InbodyTrendsEntity>> getTrends({int limit = 12}) => _read(
        Endpoints.mobileInbodyTrends,
        queryParameters: {'limit': limit.clamp(2, 60)},
        parse: readInbodyTrends,
      );

  Future<Result<InbodyPageEntity>> getTests({
    int page = 1,
    int limit = 20,
    InbodySource? source,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) =>
      get<Map<String, dynamic>>(
        Endpoints.mobileInbody,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (source != null)
            'source': source == InbodySource.manual ? 'MANUAL' : 'INBODY',
          if (dateFrom != null) 'dateFrom': _dateQuery(dateFrom),
          if (dateTo != null) 'dateTo': _dateQuery(dateTo),
        },
        fromJson: (json) => asStringKeyedMap(json),
      ).then((result) {
        return result.when(
          success: (map) {
            if (map['success'] == false) {
              return Failure(
                ServerFailure(
                  map['message']?.toString() ?? FallbackMessages.errorTryAgain,
                ),
              );
            }
            return Success(readInbodyPage(map));
          },
          failure: Failure.new,
        );
      });

  Future<Result<InbodyTestEntity>> getTest(String id) => _read(
        Endpoints.mobileInbodyById.replaceFirst('{id}', id),
        parse: readInbodyTest,
      );

  Future<Result<T>> _read<T>(
    String path, {
    required T Function(dynamic data) parse,
    Map<String, dynamic>? queryParameters,
  }) {
    return get<Map<String, dynamic>>(
      path,
      queryParameters: queryParameters,
      fromJson: (json) => asStringKeyedMap(json),
    ).then((result) {
      return result.when(
        success: (map) {
          if (map['success'] == false) {
            return Failure(
              ServerFailure(
                map['message']?.toString() ?? FallbackMessages.errorTryAgain,
              ),
            );
          }
          final payload = map.containsKey('data') ? map['data'] : map;
          return Success(parse(payload));
        },
        failure: Failure.new,
      );
    });
  }

  String _dateQuery(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
