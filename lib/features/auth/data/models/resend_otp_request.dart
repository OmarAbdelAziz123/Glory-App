import 'package:json_annotation/json_annotation.dart';

part 'resend_otp_request.g.dart';

@JsonSerializable(createFactory: false)
final class ResendOtpRequest {
  const ResendOtpRequest({
    required this.email,
    required this.purpose,
  });

  Map<String, dynamic> toJson() => _$ResendOtpRequestToJson(this);

  final String email;
  final String purpose;
}
