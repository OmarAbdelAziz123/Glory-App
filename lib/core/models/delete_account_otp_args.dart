final class DeleteAccountOtpArgs {
  const DeleteAccountOtpArgs({
    required this.email,
    this.expiresInSeconds = 60,
    this.resendCooldownSeconds = 60,
  });

  final String email;
  final int expiresInSeconds;
  final int resendCooldownSeconds;
}
