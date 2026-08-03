import 'package:json_annotation/json_annotation.dart';

part 'notifications_model.g.dart';

@JsonSerializable()
final class NotificationsModel {
  const NotificationsModel({required this.pushEnabled});

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationsModelFromJson(json);

  final bool pushEnabled;
}
