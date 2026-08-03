part of 'forgot_password_cubit.dart';

enum ForgotPasswordStatus { initial, loading, success, failure }

final class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.status = ForgotPasswordStatus.initial,
    this.otpSent,
    this.errorMessage,
  });

  final ForgotPasswordStatus status;
  final OtpSentEntity? otpSent;
  final String? errorMessage;

  bool get isLoading => status == ForgotPasswordStatus.loading;

  ForgotPasswordState copyWith({
    ForgotPasswordStatus? status,
    OtpSentEntity? otpSent,
    String? errorMessage,
  }) =>
      ForgotPasswordState(
        status: status ?? this.status,
        otpSent: otpSent ?? this.otpSent,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, otpSent, errorMessage];
}
