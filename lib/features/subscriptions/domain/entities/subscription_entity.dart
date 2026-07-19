final class SubscriptionEntity {
  const SubscriptionEntity({
    required this.id,
    required this.planName,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.price,
    this.remainingDays,
  });

  final String id;
  final String planName;
  final DateTime startDate;
  final DateTime endDate;
  final SubscriptionStatus status;
  final double price;
  final int? remainingDays;
}

enum SubscriptionStatus { active, expired, cancelled }
