import '../../../../core/network/models/pagination_meta_model.dart';
import '../../domain/entities/notification_entity.dart';
import '../models/notification_model.dart';
import '../models/notifications_api_responses.dart';

extension NotificationModelX on NotificationModel {
  NotificationEntity toEntity() => NotificationEntity(
        id: id,
        titleAr: titleAr,
        titleEn: titleEn,
        bodyAr: bodyAr,
        bodyEn: bodyEn,
        createdAt: createdAt,
        isRead: read,
        type: type,
        imageUrl: imageUrl,
      );
}

extension NotificationsApiResponseX on NotificationsApiResponse {
  NotificationsPageEntity? toPageEntity() {
    if (data == null) return null;
    final meta = this.meta ??
        const PaginationMetaModel(page: 1, limit: 20, total: 0, totalPages: 1);
    return NotificationsPageEntity(
      items: data!.map((item) => item.toEntity()).toList(),
      page: meta.page,
      totalPages: meta.totalPages,
    );
  }
}

extension NotificationApiResponseX on NotificationApiResponse {
  NotificationEntity? toEntity() => data?.toEntity();
}
