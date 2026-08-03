import 'package:json_annotation/json_annotation.dart';

part 'logout_request.g.dart';

@JsonSerializable(createFactory: false)
final class LogoutRequest {
  const LogoutRequest({required this.refreshToken});

  Map<String, dynamic> toJson() => _$LogoutRequestToJson(this);

  final String refreshToken;
}
