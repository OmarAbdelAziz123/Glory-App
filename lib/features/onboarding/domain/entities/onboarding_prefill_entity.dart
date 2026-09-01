final class OnboardingPrefillEntity {
  const OnboardingPrefillEntity({
    this.fullName,
    this.gender,
    this.phone,
    this.phoneCountryCode,
  });

  final String? fullName;
  final String? gender;
  final String? phone;
  final String? phoneCountryCode;
}

final class OnboardingStatusEntity {
  const OnboardingStatusEntity({
    required this.completed,
    this.prefill,
  });

  final bool completed;
  final OnboardingPrefillEntity? prefill;
}
