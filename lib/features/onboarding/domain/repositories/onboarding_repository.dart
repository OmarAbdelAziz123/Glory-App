import '../../../../core/result/result.dart';
import '../../data/models/onboarding_request.dart';
import '../entities/onboarding_prefill_entity.dart';

abstract interface class OnboardingRepository {
  Future<Result<OnboardingStatusEntity>> getStatus();

  Future<Result<void>> submit(OnboardingRequest request);
}
