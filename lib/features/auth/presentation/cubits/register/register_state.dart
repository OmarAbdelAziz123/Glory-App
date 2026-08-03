part of 'register_cubit.dart';

enum RegisterStatus { initial, loading, success, failure }

final class RegisterState extends Equatable {
  const RegisterState({
    this.status = RegisterStatus.initial,
    this.otpSent,
    this.errorMessage,
  });

  final RegisterStatus status;
  final OtpSentEntity? otpSent;
  final String? errorMessage;

  bool get isLoading => status == RegisterStatus.loading;

  RegisterState copyWith({
    RegisterStatus? status,
    OtpSentEntity? otpSent,
    String? errorMessage,
  }) =>
      RegisterState(
        status: status ?? this.status,
        otpSent: otpSent ?? this.otpSent,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, otpSent, errorMessage];
}
