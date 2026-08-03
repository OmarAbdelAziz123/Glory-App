import 'package:json_annotation/json_annotation.dart';

import '../../../../core/network/models/pagination_meta_model.dart';
import 'booking_model.dart';

part 'booking_api_responses.g.dart';

@JsonSerializable()
final class BookingApiResponse {
  const BookingApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory BookingApiResponse.fromJson(Map<String, dynamic> json) =>
      _$BookingApiResponseFromJson(json);

  final bool success;
  final BookingModel? data;
  final String? message;
}

@JsonSerializable()
final class BookingsApiResponse {
  const BookingsApiResponse({
    required this.success,
    this.data,
    this.meta,
    this.message,
  });

  factory BookingsApiResponse.fromJson(Map<String, dynamic> json) =>
      _$BookingsApiResponseFromJson(json);

  final bool success;
  final List<BookingModel>? data;
  final PaginationMetaModel? meta;
  final String? message;
}

@JsonSerializable()
final class BookingCheckInModel {
  const BookingCheckInModel({
    required this.id,
    required this.checkedInAt,
    required this.canCheckIn,
    required this.canRate,
    required this.package,
    required this.instructor,
    required this.subscription,
  });

  factory BookingCheckInModel.fromJson(Map<String, dynamic> json) =>
      _$BookingCheckInModelFromJson(json);

  final String id;
  final DateTime checkedInAt;
  final bool canCheckIn;
  final bool canRate;
  final BookingPackageModel package;
  final BookingInstructorModel instructor;
  final BookingSubscriptionModel subscription;
}

@JsonSerializable()
final class BookingCheckInApiResponse {
  const BookingCheckInApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory BookingCheckInApiResponse.fromJson(Map<String, dynamic> json) =>
      _$BookingCheckInApiResponseFromJson(json);

  final bool success;
  final BookingCheckInModel? data;
  final String? message;
}

@JsonSerializable()
final class AssessmentQuestionModel {
  const AssessmentQuestionModel({
    required this.id,
    required this.questionEn,
    required this.questionAr,
    required this.sortOrder,
  });

  factory AssessmentQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$AssessmentQuestionModelFromJson(json);

  final String id;
  final String questionEn;
  final String questionAr;
  final int sortOrder;
}

@JsonSerializable()
final class AssessmentQuestionsApiResponse {
  const AssessmentQuestionsApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory AssessmentQuestionsApiResponse.fromJson(Map<String, dynamic> json) =>
      _$AssessmentQuestionsApiResponseFromJson(json);

  final bool success;
  final List<AssessmentQuestionModel>? data;
  final String? message;
}

@JsonSerializable()
final class RateAnswerModel {
  const RateAnswerModel({
    required this.questionId,
    required this.answer,
  });

  factory RateAnswerModel.fromJson(Map<String, dynamic> json) =>
      _$RateAnswerModelFromJson(json);

  final String questionId;
  final int answer;

  Map<String, dynamic> toJson() => _$RateAnswerModelToJson(this);
}

@JsonSerializable()
final class RateBookingRequest {
  const RateBookingRequest({required this.answers});

  factory RateBookingRequest.fromJson(Map<String, dynamic> json) =>
      _$RateBookingRequestFromJson(json);

  final List<RateAnswerModel> answers;

  Map<String, dynamic> toJson() => _$RateBookingRequestToJson(this);
}
