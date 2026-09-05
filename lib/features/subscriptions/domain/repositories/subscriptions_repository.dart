import '../../../../core/result/result.dart';
import '../entities/subscription_entity.dart';

abstract interface class SubscriptionsRepository {
  Future<Result<SubscriptionsPageEntity>> getSubscriptions({
    int page = 1,
    int limit = 10,
  });

  Future<Result<SubscriptionEntity>> getCurrentSubscription();
}
