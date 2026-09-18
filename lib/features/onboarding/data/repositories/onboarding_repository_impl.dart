import '../../../../core/error/app_failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/onboarding_prefill_entity.dart';
import '../../domain/entities/onboarding_question_entity.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_remote_api_service.dart';
import '../fallback/onboarding_fallback_questions.dart';
import '../mappers/onboarding_mappers.dart';
import '../models/onboarding_request.dart';
import '../models/onboarding_submit_request.dart';

final class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl(this._remote);

  final OnboardingRemoteApiService _remote;

  @override
  Future<Result<OnboardingStatusEntity>> getStatus() async {
    final result = await _remote.getStatus();

    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<List<OnboardingQuestionEntity>>> getQuestions() async {
    final result = await _remote.getQuestions();

    return switch (result) {
      Success(:final data) => Success(
          data
              .map((question) => question.toEntity())
              .whereType<OnboardingQuestionEntity>()
              .toList(),
        ),
      Failure(:final failure) when _shouldUseFallbackQuestions(failure) =>
        const Success(OnboardingFallbackQuestions.questions),
      Failure(:final failure) => Failure(failure),
    };
  }

  bool _shouldUseFallbackQuestions(AppFailure failure) {
    final message = failure.message.toLowerCase();
    return message.contains('cannot get /mobile/onboarding/questions') ||
        message.contains('404');
  }

  @override
  Future<Result<void>> submit(OnboardingSubmitRequest request) async {
    final result = await _remote.submit(request);

    return switch (result) {
      Success() => const Success(null),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<void>> submitLegacy(OnboardingRequest request) async {
    final result = await _remote.submitLegacy(request);

    return switch (result) {
      Success() => const Success(null),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<String>> uploadPhoto(String filePath) =>
      _remote.uploadPhoto(filePath);
}
