import '../../../../core/error/app_failure.dart';
import '../../../../core/l10n/fallback_messages.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/repositories/subscriptions_repository.dart';
import '../datasources/subscriptions_remote_api_service.dart';
import '../mappers/subscription_mappers.dart';
import '../models/subscription_api_responses.dart';

final class SubscriptionsRepositoryImpl implements SubscriptionsRepository {
  const SubscriptionsRepositoryImpl(this._remote);

  final SubscriptionsRemoteApiService _remote;

  @override
  Future<Result<SubscriptionsPageEntity>> getSubscriptions({
    int page = 1,
    int limit = 10,
  }) async {
    final result = await _remote.getSubscriptions(page: page, limit: limit);

    return switch (result) {
      Success(:final data) => _mapPage(data),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<SubscriptionEntity>> getCurrentSubscription() async {
    final result = await _remote.getCurrentSubscription();
    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Failure(:final failure) => Failure(failure),
    };
  }

  Result<SubscriptionsPageEntity> _mapPage(SubscriptionsApiResponse data) {
    final pageEntity = data.toPageEntity();
    if (pageEntity == null) {
      return Failure(ServerFailure(FallbackMessages.errorTryAgain));
    }
    return Success(pageEntity);
  }
}
