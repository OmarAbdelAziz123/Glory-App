import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_request.g.dart';

@JsonSerializable(createFactory: false)
final class ForgotPasswordRequest {
  const ForgotPasswordRequest({required this.identifier});

  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);

  final String identifier;
}
