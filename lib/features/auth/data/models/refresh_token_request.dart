import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_request.g.dart';

@JsonSerializable(createFactory: false)
final class RefreshTokenRequest {
  const RefreshTokenRequest({required this.refreshToken});

  Map<String, dynamic> toJson() => _$RefreshTokenRequestToJson(this);

  final String refreshToken;
}
