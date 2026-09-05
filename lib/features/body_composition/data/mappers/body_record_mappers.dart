import '../../../../core/network/models/pagination_meta_model.dart';
import '../../domain/entities/body_measurement_entity.dart';
import '../models/body_record_api_responses.dart';
import '../models/body_record_model.dart';

extension BodyRecordCreatedByModelX on BodyRecordCreatedByModel {
  BodyRecordCreatedByEntity toEntity() => BodyRecordCreatedByEntity(
        id: id,
        fullName: fullName,
      );
}

extension BodyRecordModelX on BodyRecordModel {
  BodyRecordEntity toEntity() => BodyRecordEntity(
        id: id,
        type: type,
        weight: weight,
        muscleMass: muscleMass,
        bodyFat: bodyFat,
        bodyWater: bodyWater,
        visceralFat: visceralFat,
        bmi: bmi,
        bmr: bmr,
        metabolicAge: metabolicAge,
        pdfUrl: pdfUrl,
        source: source,
        recordedAt: recordedAt,
        createdBy: createdBy.toEntity(),
      );
}

extension BodyRecordsApiResponseX on BodyRecordsApiResponse {
  BodyRecordsPageEntity? toPageEntity() {
    if (data == null) return null;
    final meta = this.meta ??
        const PaginationMetaModel(page: 1, limit: 10, total: 0, totalPages: 1);
    return BodyRecordsPageEntity(
      items: data!.map((item) => item.toEntity()).toList(),
      page: meta.page,
      totalPages: meta.totalPages,
    );
  }
}
