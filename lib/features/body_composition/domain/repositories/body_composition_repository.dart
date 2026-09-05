import '../../../../core/result/result.dart';
import '../entities/body_measurement_entity.dart';

abstract interface class BodyCompositionRepository {
  Future<Result<BodyRecordsPageEntity>> getBodyRecords({
    required String type,
    int page = 1,
    int limit = 10,
  });
}
