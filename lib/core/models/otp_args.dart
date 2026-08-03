enum OtpSource { register, forgotPassword }

final class OtpArgs {
  const OtpArgs({
    required this.email,
    required this.source,
    required this.purpose,
    this.expiresInSeconds = 60,
    this.resendCooldownSeconds = 60,
  });

  final String email;
  final OtpSource source;
  final String purpose;
  final int expiresInSeconds;
  final int resendCooldownSeconds;
}

final class CreatePasswordArgs {
  const CreatePasswordArgs({
    required this.mode,
    required this.otpToken,
  });

  final CreatePasswordMode mode;
  final String otpToken;
}

enum CreatePasswordMode { register, forgotPassword }
