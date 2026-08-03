import 'package:json_annotation/json_annotation.dart';

part 'complete_registration_request.g.dart';

@JsonSerializable(createFactory: false)
final class CompleteRegistrationRequest {
  const CompleteRegistrationRequest({
    required this.otpToken,
    required this.password,
    required this.passwordConfirm,
  });

  Map<String, dynamic> toJson() => _$CompleteRegistrationRequestToJson(this);

  final String otpToken;
  final String password;
  @JsonKey(name: 'passwordConfirm')
  final String passwordConfirm;
}
