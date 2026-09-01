import 'package:json_annotation/json_annotation.dart';

import 'onboarding_prefill_model.dart';

part 'onboarding_api_responses.g.dart';

@JsonSerializable()
final class OnboardingStatusApiResponse {
  const OnboardingStatusApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory OnboardingStatusApiResponse.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStatusApiResponseFromJson(json);

  final bool success;
  final OnboardingStatusModel? data;
  final String? message;
}

@JsonSerializable()
final class OnboardingSubmitApiResponse {
  const OnboardingSubmitApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory OnboardingSubmitApiResponse.fromJson(Map<String, dynamic> json) =>
      _$OnboardingSubmitApiResponseFromJson(json);

  final bool success;
  final Map<String, dynamic>? data;
  final String? message;
}
