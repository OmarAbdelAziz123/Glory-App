import '../../domain/entities/onboarding_prefill_entity.dart';
import '../models/onboarding_prefill_model.dart';

extension OnboardingPrefillModelX on OnboardingPrefillModel {
  OnboardingPrefillEntity toEntity() => OnboardingPrefillEntity(
        fullName: fullName,
        gender: gender,
        phone: phone,
        phoneCountryCode: phoneCountryCode,
      );
}

extension OnboardingStatusModelX on OnboardingStatusModel {
  OnboardingStatusEntity toEntity() => OnboardingStatusEntity(
        completed: completed,
        prefill: prefill?.toEntity(),
      );
}
