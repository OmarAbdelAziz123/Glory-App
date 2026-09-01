import 'package:json_annotation/json_annotation.dart';

part 'onboarding_prefill_model.g.dart';

@JsonSerializable()
final class OnboardingPrefillModel {
  const OnboardingPrefillModel({
    this.fullName,
    this.gender,
    this.phone,
    this.phoneCountryCode,
  });

  factory OnboardingPrefillModel.fromJson(Map<String, dynamic> json) =>
      _$OnboardingPrefillModelFromJson(json);

  final String? fullName;
  final String? gender;
  final String? phone;
  final String? phoneCountryCode;
}

@JsonSerializable()
final class OnboardingStatusModel {
  const OnboardingStatusModel({
    required this.completed,
    this.prefill,
  });

  factory OnboardingStatusModel.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStatusModelFromJson(json);

  @JsonKey(name: 'onboardingCompleted', defaultValue: false)
  final bool completed;
  final OnboardingPrefillModel? prefill;
}
