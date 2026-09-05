// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_api_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionApiResponse _$SubscriptionApiResponseFromJson(
  Map<String, dynamic> json,
) => SubscriptionApiResponse(
  success: json['success'] as bool,
  data: json['data'] == null
      ? null
      : SubscriptionModel.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$SubscriptionApiResponseToJson(
  SubscriptionApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

SubscriptionsApiResponse _$SubscriptionsApiResponseFromJson(
  Map<String, dynamic> json,
) => SubscriptionsApiResponse(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => SubscriptionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: json['meta'] == null
      ? null
      : PaginationMetaModel.fromJson(json['meta'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$SubscriptionsApiResponseToJson(
  SubscriptionsApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'meta': instance.meta,
  'message': instance.message,
};
