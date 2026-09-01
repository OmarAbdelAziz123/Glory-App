import '../../../../core/result/result.dart';
import '../../domain/entities/onboarding_prefill_entity.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_remote_api_service.dart';
import '../mappers/onboarding_mappers.dart';
import '../models/onboarding_request.dart';

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
  Future<Result<void>> submit(OnboardingRequest request) async {
    final result = await _remote.submit(request);

    return switch (result) {
      Success() => const Success(null),
      Failure(:final failure) => Failure(failure),
    };
  }
}
