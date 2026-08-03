import 'package:json_annotation/json_annotation.dart';

part 'update_notifications_request.g.dart';

@JsonSerializable(createFactory: false)
final class UpdateNotificationsRequest {
  const UpdateNotificationsRequest({required this.enabled});

  Map<String, dynamic> toJson() => _$UpdateNotificationsRequestToJson(this);

  final bool enabled;
}
