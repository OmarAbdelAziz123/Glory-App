import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/endpoints.dart';
import '../models/booking_api_responses.dart';
import '../models/booking_model.dart';
import '../models/session_checkin_scan_request.dart';

part 'bookings_api.g.dart';

@RestApi()
abstract class BookingsApi {
  factory BookingsApi(Dio dio, {String baseUrl}) = _BookingsApi;

  @GET(Endpoints.mobileBookings)
  Future<BookingsApiResponse> getBookings({
    @Query('page') int page = 1,
    @Query('limit') int limit = 10,
    @Query('status') String? status,
    @Query('sortOrder') String? sortOrder,
  });

  @GET(Endpoints.mobileBookingById)
  Future<BookingApiResponse> getBookingById(@Path('id') String id);

  @PATCH(Endpoints.mobileBookingCancel)
  Future<BookingApiResponse> cancelBooking(@Path('id') String id);

  @POST(Endpoints.mobileBookingCheckIn)
  Future<BookingCheckInApiResponse> checkInBooking(@Path('id') String id);

  @GET(Endpoints.mobileAssessmentQuestions)
  Future<AssessmentQuestionsApiResponse> getAssessmentQuestions();

  @POST(Endpoints.mobileBookingRate)
  Future<BookingCheckInApiResponse> rateBooking(
    @Path('id') String id,
    @Body() RateBookingRequest body,
  );

  @GET(Endpoints.mobileBookingRating)
  Future<BookingRatingApiResponse> getBookingRating(@Path('id') String id);

  @POST(Endpoints.mobileSessionCheckinScan)
  Future<BookingApiResponse> scanSessionCheckin(
    @Body() SessionCheckinScanRequest body,
  );
}
