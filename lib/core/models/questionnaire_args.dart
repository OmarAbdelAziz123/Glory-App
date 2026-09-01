import '../../features/onboarding/domain/entities/onboarding_prefill_entity.dart';

final class QuestionnaireScreenArgs {
  const QuestionnaireScreenArgs({
    this.prefill,
    this.completeToHome = false,
  });

  final OnboardingPrefillEntity? prefill;
  final bool completeToHome;
}
