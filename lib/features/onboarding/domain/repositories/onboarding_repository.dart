import '../../../../core/result/result.dart';
import '../../data/models/onboarding_request.dart';
import '../../data/models/onboarding_submit_request.dart';
import '../entities/onboarding_prefill_entity.dart';
import '../entities/onboarding_question_entity.dart';

abstract interface class OnboardingRepository {
  Future<Result<OnboardingStatusEntity>> getStatus();

  Future<Result<List<OnboardingQuestionEntity>>> getQuestions();

  Future<Result<void>> submit(OnboardingSubmitRequest request);

  Future<Result<void>> submitLegacy(OnboardingRequest request);

  Future<Result<String>> uploadPhoto(String filePath);
}
