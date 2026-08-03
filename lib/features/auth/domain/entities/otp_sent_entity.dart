final class OtpSentEntity {
  const OtpSentEntity({
    required this.email,
    required this.purpose,
    required this.expiresInSeconds,
    required this.resendCooldownSeconds,
  });

  final String email;
  final String purpose;
  final int expiresInSeconds;
  final int resendCooldownSeconds;
}
