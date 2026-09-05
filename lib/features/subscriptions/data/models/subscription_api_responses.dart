import 'package:json_annotation/json_annotation.dart';

import '../../../../core/network/models/pagination_meta_model.dart';
import 'subscription_model.dart';

part 'subscription_api_responses.g.dart';

@JsonSerializable()
final class SubscriptionApiResponse {
  const SubscriptionApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory SubscriptionApiResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionApiResponseFromJson(json);

  final bool success;
  final SubscriptionModel? data;
  final String? message;
}

@JsonSerializable()
final class SubscriptionsApiResponse {
  const SubscriptionsApiResponse({
    required this.success,
    this.data,
    this.meta,
    this.message,
  });

  factory SubscriptionsApiResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionsApiResponseFromJson(json);

  final bool success;
  final List<SubscriptionModel>? data;
  final PaginationMetaModel? meta;
  final String? message;
}
