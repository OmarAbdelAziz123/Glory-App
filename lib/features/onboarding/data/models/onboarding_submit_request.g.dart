// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_submit_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$OnboardingSubmitRequestToJson(
  OnboardingSubmitRequest instance,
) => <String, dynamic>{
  'answers': instance.answers.map((e) => e.toJson()).toList(),
};

Map<String, dynamic> _$OnboardingAnswerModelToJson(
  OnboardingAnswerModel instance,
) => <String, dynamic>{
  'questionId': instance.questionId,
  'value': ?instance.value,
  'values': ?instance.values,
  'fileUrls': ?instance.fileUrls,
};
