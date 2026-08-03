import 'package:json_annotation/json_annotation.dart';

part 'otp_sent_model.g.dart';

@JsonSerializable()
final class OtpSentModel {
  const OtpSentModel({
    required this.email,
    required this.purpose,
    required this.expiresInSeconds,
    required this.resendCooldownSeconds,
  });

  factory OtpSentModel.fromJson(Map<String, dynamic> json) =>
      _$OtpSentModelFromJson(json);

  final String email;
  final String purpose;
  final int expiresInSeconds;
  final int resendCooldownSeconds;
}
