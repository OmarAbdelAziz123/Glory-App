import '../../../../core/result/result.dart';
import '../entities/booking_entity.dart';

abstract interface class BookingsRepository {
  Future<Result<BookingsPageEntity>> getBookings({
    int page = 1,
    int limit = 10,
    String? status,
    String? sortOrder,
  });

  Future<Result<BookingEntity>> getBookingById(String id);

  Future<Result<BookingEntity>> cancelBooking(String id);

  Future<Result<BookingCheckInResultEntity>> checkInBooking(String id);

  Future<Result<List<AssessmentQuestionEntity>>> getAssessmentQuestions();

  Future<Result<BookingCheckInResultEntity>> rateBooking({
    required String bookingId,
    required Map<String, int> answers,
  });
}
