import '../../../../core/network/models/pagination_meta_model.dart';
import '../../domain/entities/subscription_entity.dart';
import '../models/subscription_api_responses.dart';
import '../models/subscription_model.dart';

extension SubscriptionPackageModelX on SubscriptionPackageModel {
  SubscriptionPackageEntity toEntity() => SubscriptionPackageEntity(
        id: id,
        nameEn: nameEn,
        nameAr: nameAr,
        membershipType: membershipType,
        durationUnit: durationUnit,
        durationValue: durationValue,
      );
}

extension SubscriptionModelX on SubscriptionModel {
  SubscriptionEntity toEntity() => SubscriptionEntity(
        id: id,
        package: package.toEntity(),
        startDate: startDate,
        endDate: endDate,
        status: _mapStatus(status),
        price: double.tryParse(price) ?? 0,
        sessionCount: sessionCount,
        remainingSessions: remainingSessions,
        remainingDays: remainingDays,
      );
}

extension SubscriptionsApiResponseX on SubscriptionsApiResponse {
  SubscriptionsPageEntity? toPageEntity() {
    if (data == null) return null;
    final meta = this.meta ??
        const PaginationMetaModel(page: 1, limit: 10, total: 0, totalPages: 1);
    return SubscriptionsPageEntity(
      items: data!.map((item) => item.toEntity()).toList(),
      page: meta.page,
      totalPages: meta.totalPages,
    );
  }
}

SubscriptionStatus _mapStatus(String value) => switch (value.toUpperCase()) {
      'ACTIVE' => SubscriptionStatus.active,
      'EXPIRED' => SubscriptionStatus.expired,
      'CANCELLED' || 'CANCELED' => SubscriptionStatus.cancelled,
      _ => SubscriptionStatus.active,
    };
