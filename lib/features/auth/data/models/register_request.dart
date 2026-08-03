import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable(createFactory: false)
final class RegisterRequest {
  const RegisterRequest({
    required this.fullName,
    required this.phoneCountryCode,
    required this.phone,
    required this.email,
  });

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);

  final String fullName;
  final String phoneCountryCode;
  final String phone;
  final String email;
}
