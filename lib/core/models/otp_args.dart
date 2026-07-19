enum OtpSource { register, forgotPassword }

final class OtpArgs {
  const OtpArgs({required this.email, required this.source});

  final String email;
  final OtpSource source;
}
