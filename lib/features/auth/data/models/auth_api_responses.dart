import 'package:json_annotation/json_annotation.dart';

import 'login_model.dart';
import 'member_model.dart';
import 'notifications_model.dart';
import 'otp_sent_model.dart';
import 'verify_otp_model.dart';
import 'reset_password_model.dart';

part 'auth_api_responses.g.dart';

@JsonSerializable()
final class OtpSentApiResponse {
  const OtpSentApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory OtpSentApiResponse.fromJson(Map<String, dynamic> json) =>
      _$OtpSentApiResponseFromJson(json);

  final bool success;
  final OtpSentModel? data;
  final String? message;
}

@JsonSerializable()
final class VerifyOtpApiResponse {
  const VerifyOtpApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory VerifyOtpApiResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpApiResponseFromJson(json);

  final bool success;
  final VerifyOtpModel? data;
  final String? message;
}

@JsonSerializable()
final class MemberApiResponse {
  const MemberApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory MemberApiResponse.fromJson(Map<String, dynamic> json) =>
      _$MemberApiResponseFromJson(json);

  final bool success;
  final MemberModel? data;
  final String? message;
}

@JsonSerializable()
final class LoginApiResponse {
  const LoginApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory LoginApiResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginApiResponseFromJson(json);

  final bool success;
  final LoginModel? data;
  final String? message;
}

@JsonSerializable()
final class LogoutApiResponse {
  const LogoutApiResponse({
    required this.success,
    this.message,
  });

  factory LogoutApiResponse.fromJson(Map<String, dynamic> json) =>
      _$LogoutApiResponseFromJson(json);

  final bool success;
  final String? message;
}

@JsonSerializable()
final class ResetPasswordApiResponse {
  const ResetPasswordApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory ResetPasswordApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordApiResponseFromJson(json);

  final bool success;
  final ResetPasswordModel? data;
  final String? message;
}

@JsonSerializable()
final class NotificationsApiResponse {
  const NotificationsApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory NotificationsApiResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationsApiResponseFromJson(json);

  final bool success;
  final NotificationsModel? data;
  final String? message;
}
