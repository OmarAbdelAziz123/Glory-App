import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
final class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.bodyEn,
    required this.bodyAr,
    required this.type,
    this.imageUrl,
    required this.read,
    this.readAt,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  final String id;
  final String titleEn;
  final String titleAr;
  final String bodyEn;
  final String bodyAr;
  final String type;
  final String? imageUrl;
  final bool read;
  final DateTime? readAt;
  final DateTime createdAt;
}

@JsonSerializable()
final class UnreadCountModel {
  const UnreadCountModel({required this.count});

  factory UnreadCountModel.fromJson(Map<String, dynamic> json) =>
      _$UnreadCountModelFromJson(json);

  final int count;
}

@JsonSerializable()
final class ReadAllModel {
  const ReadAllModel({required this.updated});

  factory ReadAllModel.fromJson(Map<String, dynamic> json) =>
      _$ReadAllModelFromJson(json);

  final int updated;
}
