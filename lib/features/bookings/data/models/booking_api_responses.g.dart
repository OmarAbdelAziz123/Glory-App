// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_api_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingApiResponse _$BookingApiResponseFromJson(Map<String, dynamic> json) =>
    BookingApiResponse(
      success: json['success'] as bool,
      data: json['data'] == null
          ? null
          : BookingModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$BookingApiResponseToJson(BookingApiResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'message': instance.message,
    };

BookingsApiResponse _$BookingsApiResponseFromJson(Map<String, dynamic> json) =>
    BookingsApiResponse(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : PaginationMetaModel.fromJson(json['meta'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$BookingsApiResponseToJson(
  BookingsApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'meta': instance.meta,
  'message': instance.message,
};

BookingCheckInModel _$BookingCheckInModelFromJson(Map<String, dynamic> json) =>
    BookingCheckInModel(
      id: json['id'] as String,
      checkedInAt: DateTime.parse(json['checkedInAt'] as String),
      canCheckIn: json['canCheckIn'] as bool,
      canRate: json['canRate'] as bool,
      package: BookingPackageModel.fromJson(
        json['package'] as Map<String, dynamic>,
      ),
      instructor: BookingInstructorModel.fromJson(
        json['instructor'] as Map<String, dynamic>,
      ),
      subscription: BookingSubscriptionModel.fromJson(
        json['subscription'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$BookingCheckInModelToJson(
  BookingCheckInModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'checkedInAt': instance.checkedInAt.toIso8601String(),
  'canCheckIn': instance.canCheckIn,
  'canRate': instance.canRate,
  'package': instance.package,
  'instructor': instance.instructor,
  'subscription': instance.subscription,
};

BookingCheckInApiResponse _$BookingCheckInApiResponseFromJson(
  Map<String, dynamic> json,
) => BookingCheckInApiResponse(
  success: json['success'] as bool,
  data: json['data'] == null
      ? null
      : BookingCheckInModel.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$BookingCheckInApiResponseToJson(
  BookingCheckInApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

AssessmentQuestionModel _$AssessmentQuestionModelFromJson(
  Map<String, dynamic> json,
) => AssessmentQuestionModel(
  id: json['id'] as String,
  questionEn: json['questionEn'] as String,
  questionAr: json['questionAr'] as String,
  sortOrder: (json['sortOrder'] as num).toInt(),
);

Map<String, dynamic> _$AssessmentQuestionModelToJson(
  AssessmentQuestionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'questionEn': instance.questionEn,
  'questionAr': instance.questionAr,
  'sortOrder': instance.sortOrder,
};

AssessmentQuestionsApiResponse _$AssessmentQuestionsApiResponseFromJson(
  Map<String, dynamic> json,
) => AssessmentQuestionsApiResponse(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => AssessmentQuestionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  message: json['message'] as String?,
);

Map<String, dynamic> _$AssessmentQuestionsApiResponseToJson(
  AssessmentQuestionsApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

RateAnswerModel _$RateAnswerModelFromJson(Map<String, dynamic> json) =>
    RateAnswerModel(
      questionId: json['questionId'] as String,
      answer: (json['answer'] as num).toInt(),
    );

Map<String, dynamic> _$RateAnswerModelToJson(RateAnswerModel instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'answer': instance.answer,
    };

RateBookingRequest _$RateBookingRequestFromJson(Map<String, dynamic> json) =>
    RateBookingRequest(
      answers: (json['answers'] as List<dynamic>)
          .map((e) => RateAnswerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RateBookingRequestToJson(RateBookingRequest instance) =>
    <String, dynamic>{'answers': instance.answers};
