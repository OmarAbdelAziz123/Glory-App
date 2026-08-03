import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable(createFactory: false)
final class LoginRequest {
  const LoginRequest({
    required this.identifier,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);

  final String identifier;
  final String password;
}
