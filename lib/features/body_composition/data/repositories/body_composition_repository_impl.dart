import '../../../../core/error/app_failure.dart';
import '../../../../core/l10n/fallback_messages.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/body_measurement_entity.dart';
import '../../domain/repositories/body_composition_repository.dart';
import '../datasources/body_records_remote_api_service.dart';
import '../mappers/body_record_mappers.dart';
import '../models/body_record_api_responses.dart';

final class BodyCompositionRepositoryImpl implements BodyCompositionRepository {
  const BodyCompositionRepositoryImpl(this._remote);

  final BodyRecordsRemoteApiService _remote;

  @override
  Future<Result<BodyRecordsPageEntity>> getBodyRecords({
    required String type,
    int page = 1,
    int limit = 10,
  }) async {
    final result = await _remote.getBodyRecords(
      type: type,
      page: page,
      limit: limit,
    );

    return switch (result) {
      Success(:final data) => _mapPage(data),
      Failure(:final failure) => Failure(failure),
    };
  }

  Result<BodyRecordsPageEntity> _mapPage(BodyRecordsApiResponse data) {
    final pageEntity = data.toPageEntity();
    if (pageEntity == null) {
      return Failure(ServerFailure(FallbackMessages.errorTryAgain));
    }
    return Success(pageEntity);
  }
}
