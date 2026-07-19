import '../../../../core/result/result.dart';
import '../entities/booking_entity.dart';

abstract interface class BookingsRepository {
  Future<Result<List<BookingEntity>>> getBookings();

  Future<Result<BookingEntity>> getBookingById(String id);

  Future<Result<void>> createBooking({
    required String sessionId,
    required DateTime dateTime,
  });

  Future<Result<void>> cancelBooking(String id);
}
