// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_prefill_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnboardingPrefillModel _$OnboardingPrefillModelFromJson(
  Map<String, dynamic> json,
) => OnboardingPrefillModel(
  fullName: json['fullName'] as String?,
  gender: json['gender'] as String?,
  phone: json['phone'] as String?,
  phoneCountryCode: json['phoneCountryCode'] as String?,
);

Map<String, dynamic> _$OnboardingPrefillModelToJson(
  OnboardingPrefillModel instance,
) => <String, dynamic>{
  'fullName': instance.fullName,
  'gender': instance.gender,
  'phone': instance.phone,
  'phoneCountryCode': instance.phoneCountryCode,
};

OnboardingStatusModel _$OnboardingStatusModelFromJson(
  Map<String, dynamic> json,
) => OnboardingStatusModel(
  completed:
      OnboardingStatusModel._readCompleted(json, 'completed') as bool? ?? false,
  prefill: json['prefill'] == null
      ? null
      : OnboardingPrefillModel.fromJson(
          json['prefill'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$OnboardingStatusModelToJson(
  OnboardingStatusModel instance,
) => <String, dynamic>{
  'completed': instance.completed,
  'prefill': instance.prefill,
};
