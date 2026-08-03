import 'package:json_annotation/json_annotation.dart';

part 'reset_password_request.g.dart';

@JsonSerializable(createFactory: false)
final class ResetPasswordRequest {
  const ResetPasswordRequest({
    required this.otpToken,
    required this.password,
    required this.passwordConfirm,
  });

  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);

  final String otpToken;
  final String password;
  @JsonKey(name: 'passwordConfirm')
  final String passwordConfirm;
}
