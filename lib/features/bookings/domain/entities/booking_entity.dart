final class BookingEntity {
  const BookingEntity({
    required this.id,
    required this.type,
    required this.status,
    required this.dateTime,
    required this.packageNameAr,
    required this.packageNameEn,
    required this.instructorName,
    this.instructorAvatarUrl,
    this.branchNameEn,
    this.checkedInAt,
    this.remainingSessions,
    required this.canCancel,
    required this.canCheckIn,
    required this.canRate,
  });

  final String id;
  final String type;
  final String status;
  final DateTime dateTime;
  final String packageNameAr;
  final String packageNameEn;
  final String instructorName;
  final String? instructorAvatarUrl;
  final String? branchNameEn;
  final DateTime? checkedInAt;
  final int? remainingSessions;
  final bool canCancel;
  final bool canCheckIn;
  final bool canRate;

  BookingEntity copyWith({
    String? status,
    DateTime? checkedInAt,
    int? remainingSessions,
    bool? canCancel,
    bool? canCheckIn,
    bool? canRate,
  }) {
    return BookingEntity(
      id: id,
      type: type,
      status: status ?? this.status,
      dateTime: dateTime,
      packageNameAr: packageNameAr,
      packageNameEn: packageNameEn,
      instructorName: instructorName,
      instructorAvatarUrl: instructorAvatarUrl,
      branchNameEn: branchNameEn,
      checkedInAt: checkedInAt ?? this.checkedInAt,
      remainingSessions: remainingSessions ?? this.remainingSessions,
      canCancel: canCancel ?? this.canCancel,
      canCheckIn: canCheckIn ?? this.canCheckIn,
      canRate: canRate ?? this.canRate,
    );
  }
}

final class BookingCheckInResultEntity {
  const BookingCheckInResultEntity({
    required this.bookingId,
    required this.packageNameAr,
    required this.packageNameEn,
    required this.instructorName,
    required this.remainingSessions,
  });

  final String bookingId;
  final String packageNameAr;
  final String packageNameEn;
  final String instructorName;
  final int remainingSessions;
}

final class AssessmentQuestionEntity {
  const AssessmentQuestionEntity({
    required this.id,
    required this.questionAr,
    required this.questionEn,
    required this.sortOrder,
  });

  final String id;
  final String questionAr;
  final String questionEn;
  final int sortOrder;
}

final class BookingsPageEntity {
  const BookingsPageEntity({
    required this.items,
    required this.page,
    required this.totalPages,
  });

  final List<BookingEntity> items;
  final int page;
  final int totalPages;

  bool get hasMore => page < totalPages;
}
