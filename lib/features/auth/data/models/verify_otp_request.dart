import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_request.g.dart';

@JsonSerializable(createFactory: false)
final class VerifyOtpRequest {
  const VerifyOtpRequest({
    required this.email,
    required this.purpose,
    required this.code,
  });

  Map<String, dynamic> toJson() => _$VerifyOtpRequestToJson(this);

  final String email;
  final String purpose;
  final String code;
}
