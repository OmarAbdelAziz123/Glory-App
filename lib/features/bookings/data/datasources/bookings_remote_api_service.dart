import 'package:dio/dio.dart';
import '../../../../core/l10n/fallback_messages.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/result/result.dart';
import '../models/booking_api_responses.dart';
import '../models/booking_model.dart';
import 'bookings_api.dart';

final class BookingsRemoteApiService extends ApiService {
  BookingsRemoteApiService(super.dio, this._bookingsApi);

  final BookingsApi _bookingsApi;

  Future<Result<BookingsApiResponse>> getBookings({
    int page = 1,
    int limit = 10,
    String? status,
    String? sortOrder,
  }) =>
      _guard(() async {
        final response = await _bookingsApi.getBookings(
          page: page,
          limit: limit,
          status: status,
          sortOrder: sortOrder,
        );
        if (!response.success) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return Success(response);
      });

  Future<Result<BookingModel>> getBookingById(String id) => _guard(() async {
        final response = await _bookingsApi.getBookingById(id);
        return _mapBookingResponse(response);
      });

  Future<Result<BookingModel>> cancelBooking(String id) => _guard(() async {
        final response = await _bookingsApi.cancelBooking(id);
        return _mapBookingResponse(response);
      });

  Future<Result<BookingCheckInModel>> checkInBooking(String id) =>
      _guard(() async {
        final response = await _bookingsApi.checkInBooking(id);
        if (!response.success || response.data == null) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return Success(response.data!);
      });

  Future<Result<List<AssessmentQuestionModel>>> getAssessmentQuestions() =>
      _guard(() async {
        final response = await _bookingsApi.getAssessmentQuestions();
        if (!response.success || response.data == null) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return Success(response.data!);
      });

  Future<Result<BookingCheckInModel>> rateBooking({
    required String id,
    required RateBookingRequest request,
  }) =>
      _guard(() async {
        final response = await _bookingsApi.rateBooking(id, request);
        if (!response.success || response.data == null) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return Success(response.data!);
      });

  Result<BookingModel> _mapBookingResponse(BookingApiResponse response) {
    if (!response.success || response.data == null) {
      return Failure(
        ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
      );
    }
    return Success(response.data!);
  }

  Future<Result<T>> _guard<T>(Future<Result<T>> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      final inner = e.error;
      if (inner is AppException) {
        return Failure(_mapException(inner));
      }
      return Failure(
        switch (e.type) {
          DioExceptionType.connectionTimeout ||
          DioExceptionType.receiveTimeout ||
          DioExceptionType.sendTimeout ||
          DioExceptionType.connectionError =>
            NetworkFailure(FallbackMessages.noInternet),
          _ => ServerFailure(e.message ?? FallbackMessages.errorGeneral),
        },
      );
    } on AppException catch (e) {
      return Failure(_mapException(e));
    } catch (e) {
      return Failure(ServerFailure(e.toString()));
    }
  }

  AppFailure _mapException(AppException e) => switch (e) {
        NetworkException() => NetworkFailure(e.message),
        UnauthorizedException() => UnauthorizedFailure(e.message),
        ServerException() => ServerFailure(e.message),
        CacheException() => CacheFailure(e.message),
        ValidationException() => ValidationFailure(e.message),
      };
}
