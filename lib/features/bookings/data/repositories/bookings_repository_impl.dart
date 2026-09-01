import '../../../../core/error/app_failure.dart';
import '../../../../core/l10n/fallback_messages.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/bookings_repository.dart';
import '../datasources/bookings_remote_api_service.dart';
import '../mappers/booking_mappers.dart';
import '../models/booking_api_responses.dart';

final class BookingsRepositoryImpl implements BookingsRepository {
  const BookingsRepositoryImpl(this._remote);

  final BookingsRemoteApiService _remote;

  @override
  Future<Result<BookingsPageEntity>> getBookings({
    int page = 1,
    int limit = 10,
    String? status,
    String? sortOrder,
  }) async {
    final result = await _remote.getBookings(
      page: page,
      limit: limit,
      status: status,
      sortOrder: sortOrder,
    );

    return switch (result) {
      Success(:final data) => _mapPage(data),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<BookingEntity>> getBookingById(String id) async {
    final result = await _remote.getBookingById(id);
    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<BookingEntity>> cancelBooking(String id) async {
    final result = await _remote.cancelBooking(id);
    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<BookingCheckInResultEntity>> checkInBooking(String id) async {
    final result = await _remote.checkInBooking(id);
    return switch (result) {
      Success(:final data) => Success(data.toResultEntity()),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<List<AssessmentQuestionEntity>>> getAssessmentQuestions() async {
    final result = await _remote.getAssessmentQuestions();
    return switch (result) {
      Success(:final data) =>
        Success(data.map((q) => q.toEntity()).toList()),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<BookingCheckInResultEntity>> rateBooking({
    required String bookingId,
    required Map<String, int> answers,
  }) async {
    final result = await _remote.rateBooking(
      id: bookingId,
      request: RateBookingRequest(
        answers: answers.entries
            .map((e) => RateAnswerModel(questionId: e.key, answer: e.value))
            .toList(),
      ),
    );

    return switch (result) {
      Success(:final data) => Success(data.toResultEntity()),
      Failure(:final failure) => Failure(failure),
    };
  }

  Result<BookingsPageEntity> _mapPage(BookingsApiResponse data) {
    final pageEntity = data.toPageEntity();
    if (pageEntity == null) {
      return Failure(ServerFailure(FallbackMessages.errorTryAgain));
    }
    return Success(pageEntity);
  }
}
