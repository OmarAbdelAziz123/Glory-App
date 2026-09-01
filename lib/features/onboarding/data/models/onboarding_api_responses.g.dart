// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_api_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnboardingStatusApiResponse _$OnboardingStatusApiResponseFromJson(
  Map<String, dynamic> json,
) => OnboardingStatusApiResponse(
  success: json['success'] as bool,
  data: json['data'] == null
      ? null
      : OnboardingStatusModel.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$OnboardingStatusApiResponseToJson(
  OnboardingStatusApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

OnboardingSubmitApiResponse _$OnboardingSubmitApiResponseFromJson(
  Map<String, dynamic> json,
) => OnboardingSubmitApiResponse(
  success: json['success'] as bool,
  data: json['data'] as Map<String, dynamic>?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$OnboardingSubmitApiResponseToJson(
  OnboardingSubmitApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};
