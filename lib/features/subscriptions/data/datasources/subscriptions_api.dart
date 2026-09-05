import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/endpoints.dart';
import '../models/subscription_api_responses.dart';

part 'subscriptions_api.g.dart';

@RestApi()
abstract class SubscriptionsApi {
  factory SubscriptionsApi(Dio dio, {String baseUrl}) = _SubscriptionsApi;

  @GET(Endpoints.mobileSubscriptions)
  Future<SubscriptionsApiResponse> getSubscriptions({
    @Query('page') int page = 1,
    @Query('limit') int limit = 10,
  });

  @GET(Endpoints.mobileSubscriptionsCurrent)
  Future<SubscriptionApiResponse> getCurrentSubscription();
}
