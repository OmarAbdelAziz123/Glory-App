final class BookingEntity {
  const BookingEntity({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.status,
    this.instructorName,
    this.location,
  });

  final String id;
  final String title;
  final DateTime dateTime;
  final BookingStatus status;
  final String? instructorName;
  final String? location;
}

enum BookingStatus { upcoming, completed, cancelled }
