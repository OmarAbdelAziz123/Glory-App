final class HomeEntity {
  const HomeEntity({
    required this.memberName,
    required this.remainingDays,
    this.nextBooking,
    this.unreadNotificationsCount = 0,
  });

  final String memberName;
  final int remainingDays;
  final DateTime? nextBooking;
  final int unreadNotificationsCount;
}
