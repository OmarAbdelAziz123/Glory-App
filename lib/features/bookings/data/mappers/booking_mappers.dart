import '../../../../core/network/models/pagination_meta_model.dart';
import '../../domain/entities/booking_entity.dart';
import '../models/booking_api_responses.dart';
import '../models/booking_model.dart';

extension BookingModelX on BookingModel {
  BookingEntity toEntity() => BookingEntity(
        id: id,
        type: type,
        status: status,
        dateTime: dateTime,
        packageNameAr: package.nameAr,
        packageNameEn: package.nameEn,
        instructorName: instructor.fullName,
        instructorAvatarUrl: instructor.avatarUrl,
        branchNameEn: branch.nameEn,
        checkedInAt: checkedInAt,
        remainingSessions: subscription.remainingSessions,
        canCancel: canCancel,
        canCheckIn: canCheckIn,
        canRate: canRate,
      );
}

extension BookingsApiResponseX on BookingsApiResponse {
  BookingsPageEntity? toPageEntity() {
    if (data == null) return null;
    final meta = this.meta ??
        const PaginationMetaModel(page: 1, limit: 10, total: 0, totalPages: 1);
    return BookingsPageEntity(
      items: data!.map((item) => item.toEntity()).toList(),
      page: meta.page,
      totalPages: meta.totalPages,
    );
  }
}

extension BookingCheckInModelX on BookingCheckInModel {
  BookingCheckInResultEntity toResultEntity() => BookingCheckInResultEntity(
        bookingId: id,
        packageNameAr: package.nameAr,
        packageNameEn: package.nameEn,
        instructorName: instructor.fullName,
        remainingSessions: subscription.remainingSessions,
      );
}

extension AssessmentQuestionModelX on AssessmentQuestionModel {
  AssessmentQuestionEntity toEntity() => AssessmentQuestionEntity(
        id: id,
        questionAr: questionAr,
        questionEn: questionEn,
        sortOrder: sortOrder,
      );
}
