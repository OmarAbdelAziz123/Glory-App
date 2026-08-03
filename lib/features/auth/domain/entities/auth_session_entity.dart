import 'member_entity.dart';

final class VerifyOtpEntity {
  const VerifyOtpEntity({
    required this.otpToken,
    required this.purpose,
  });

  final String otpToken;
  final String purpose;
}

final class AuthSessionEntity {
  const AuthSessionEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.member,
  });

  final String accessToken;
  final String refreshToken;
  final MemberEntity member;
}
