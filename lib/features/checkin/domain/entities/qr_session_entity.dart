final class QrSessionEntity {
  const QrSessionEntity({
    required this.id,
    required this.token,
    required this.expiresAt,
    required this.expiresInSeconds,
  });

  final String id;
  final String token;
  final DateTime expiresAt;
  final int expiresInSeconds;
}

enum QrSessionStatus { pending, expired, consumed }

final class QrStatusEntity {
  const QrStatusEntity({
    required this.id,
    required this.status,
    required this.expiresAt,
    this.daysRemaining,
  });

  final String id;
  final QrSessionStatus status;
  final DateTime expiresAt;
  final int? daysRemaining;
}
