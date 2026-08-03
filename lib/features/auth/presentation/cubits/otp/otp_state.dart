part of 'otp_cubit.dart';

enum OtpStatus {
  initial,
  verifying,
  verified,
  resending,
  resent,
  failure,
}

final class OtpState extends Equatable {
  const OtpState({
    this.status = OtpStatus.initial,
    this.verifyResult,
    this.otpSent,
    this.errorMessage,
  });

  final OtpStatus status;
  final VerifyOtpEntity? verifyResult;
  final OtpSentEntity? otpSent;
  final String? errorMessage;

  bool get isVerifying => status == OtpStatus.verifying;
  bool get isResending => status == OtpStatus.resending;

  OtpState copyWith({
    OtpStatus? status,
    VerifyOtpEntity? verifyResult,
    OtpSentEntity? otpSent,
    String? errorMessage,
  }) =>
      OtpState(
        status: status ?? this.status,
        verifyResult: verifyResult ?? this.verifyResult,
        otpSent: otpSent ?? this.otpSent,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, verifyResult, otpSent, errorMessage];
}
