import 'package:json_annotation/json_annotation.dart';

part 'onboarding_question_model.g.dart';

@JsonSerializable()
final class OnboardingQuestionOptionModel {
  const OnboardingQuestionOptionModel({
    required this.value,
    required this.labelEn,
    required this.labelAr,
  });

  factory OnboardingQuestionOptionModel.fromJson(Map<String, dynamic> json) =>
      _$OnboardingQuestionOptionModelFromJson(json);

  final String value;
  final String labelEn;
  final String labelAr;
}

@JsonSerializable()
final class OnboardingQuestionModel {
  const OnboardingQuestionModel({
    required this.id,
    required this.questionEn,
    required this.questionAr,
    required this.type,
    this.options = const [],
    required this.required,
    @JsonKey(name: 'showIfQuestionId') this.showOnlyIfQuestionId,
    @JsonKey(name: 'showIfValue') this.showOnlyIfAnswerValue,
    required this.sortOrder,
  });

  factory OnboardingQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$OnboardingQuestionModelFromJson(json);

  final String id;
  final String questionEn;
  final String questionAr;
  final String type;
  final List<OnboardingQuestionOptionModel> options;
  final bool required;
  final String? showOnlyIfQuestionId;
  final dynamic showOnlyIfAnswerValue;
  final int sortOrder;
}

@JsonSerializable()
final class OnboardingQuestionsApiResponse {
  const OnboardingQuestionsApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory OnboardingQuestionsApiResponse.fromJson(Map<String, dynamic> json) =>
      _$OnboardingQuestionsApiResponseFromJson(json);

  final bool success;
  final List<OnboardingQuestionModel>? data;
  final String? message;
}
