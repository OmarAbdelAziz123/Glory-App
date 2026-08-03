final class NotificationEntity {
  const NotificationEntity({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.bodyAr,
    required this.bodyEn,
    required this.createdAt,
    this.isRead = false,
    this.type,
    this.imageUrl,
  });

  final String id;
  final String titleAr;
  final String titleEn;
  final String bodyAr;
  final String bodyEn;
  final DateTime createdAt;
  final bool isRead;
  final String? type;
  final String? imageUrl;

  NotificationEntity copyWith({bool? isRead}) {
    return NotificationEntity(
      id: id,
      titleAr: titleAr,
      titleEn: titleEn,
      bodyAr: bodyAr,
      bodyEn: bodyEn,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      type: type,
      imageUrl: imageUrl,
    );
  }
}

final class NotificationsPageEntity {
  const NotificationsPageEntity({
    required this.items,
    required this.page,
    required this.totalPages,
  });

  final List<NotificationEntity> items;
  final int page;
  final int totalPages;

  bool get hasMore => page < totalPages;
}
