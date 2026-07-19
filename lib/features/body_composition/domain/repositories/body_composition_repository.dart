import '../../../../core/result/result.dart';
import '../entities/body_measurement_entity.dart';

abstract interface class BodyCompositionRepository {
  Future<Result<List<BodyMeasurementEntity>>> getBodyMeasurements();

  Future<Result<List<SizeMeasurementEntity>>> getSizeMeasurements();

  Future<Result<void>> addBodyMeasurement(BodyMeasurementEntity measurement);

  Future<Result<void>> addSizeMeasurement(SizeMeasurementEntity measurement);
}
