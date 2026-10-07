final class SubscriptionPackageEntity {
  const SubscriptionPackageEntity({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.membershipType,
    required this.durationUnit,
    required this.durationValue,
  });

  final String id;
  final String nameEn;
  final String nameAr;
  final String membershipType;
  final String durationUnit;
  final int durationValue;
}

final class SubscriptionEntity {
  const SubscriptionEntity({
    required this.id,
    required this.package,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.price,
    this.sessionCount,
    this.remainingSessions,
    this.remainingDays,
  });

  final String id;
  final SubscriptionPackageEntity package;
  final DateTime startDate;
  final DateTime endDate;
  final SubscriptionStatus status;
  final double price;
  final int? sessionCount;
  final int? remainingSessions;
  final int? remainingDays;

  String packageName({required bool isArabic}) {
    if (isArabic) {
      return package.nameAr.isNotEmpty ? package.nameAr : package.nameEn;
    }
    return package.nameEn.isNotEmpty ? package.nameEn : package.nameAr;
  }
}

enum SubscriptionStatus { active, expired, cancelled }

final class SubscriptionsPageEntity {
  const SubscriptionsPageEntity({
    required this.items,
    required this.page,
    required this.totalPages,
  });

  final List<SubscriptionEntity> items;
  final int page;
  final int totalPages;

  bool get hasMore => page < totalPages;
}
