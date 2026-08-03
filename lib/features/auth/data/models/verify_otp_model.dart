import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_model.g.dart';

@JsonSerializable()
final class VerifyOtpModel {
  const VerifyOtpModel({
    required this.otpToken,
    required this.purpose,
  });

  factory VerifyOtpModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpModelFromJson(json);

  final String otpToken;
  final String purpose;
}
