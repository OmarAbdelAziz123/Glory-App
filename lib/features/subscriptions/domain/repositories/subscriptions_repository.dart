import '../../../../core/result/result.dart';
import '../entities/subscription_entity.dart';

abstract interface class SubscriptionsRepository {
  Future<Result<SubscriptionEntity>> getCurrentSubscription();

  Future<Result<List<SubscriptionEntity>>> getSubscriptionHistory();
}
