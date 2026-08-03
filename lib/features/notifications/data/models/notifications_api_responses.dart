import 'package:json_annotation/json_annotation.dart';

import 'notification_model.dart';
import '../../../../core/network/models/pagination_meta_model.dart';

part 'notifications_api_responses.g.dart';

@JsonSerializable()
final class NotificationsApiResponse {
  const NotificationsApiResponse({
    required this.success,
    this.data,
    this.meta,
    this.message,
  });

  factory NotificationsApiResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationsApiResponseFromJson(json);

  final bool success;
  final List<NotificationModel>? data;
  final PaginationMetaModel? meta;
  final String? message;
}

@JsonSerializable()
final class NotificationApiResponse {
  const NotificationApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory NotificationApiResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationApiResponseFromJson(json);

  final bool success;
  final NotificationModel? data;
  final String? message;
}

@JsonSerializable()
final class UnreadCountApiResponse {
  const UnreadCountApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory UnreadCountApiResponse.fromJson(Map<String, dynamic> json) =>
      _$UnreadCountApiResponseFromJson(json);

  final bool success;
  final UnreadCountModel? data;
  final String? message;
}

@JsonSerializable()
final class ReadAllApiResponse {
  const ReadAllApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory ReadAllApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ReadAllApiResponseFromJson(json);

  final bool success;
  final ReadAllModel? data;
  final String? message;
}
