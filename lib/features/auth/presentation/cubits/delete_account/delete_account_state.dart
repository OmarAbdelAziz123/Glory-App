part of 'delete_account_cubit.dart';

enum DeleteAccountStatus {
  initial,
  requesting,
  otpSent,
  resending,
  confirming,
  deleted,
  failure,
}

final class DeleteAccountState extends Equatable {
  const DeleteAccountState({
    this.status = DeleteAccountStatus.initial,
    this.otpSent,
    this.errorMessage,
  });

  final DeleteAccountStatus status;
  final OtpSentEntity? otpSent;
  final String? errorMessage;

  bool get isBusy =>
      status == DeleteAccountStatus.requesting ||
      status == DeleteAccountStatus.confirming;

  bool get isResending => status == DeleteAccountStatus.resending;

  DeleteAccountState copyWith({
    DeleteAccountStatus? status,
    OtpSentEntity? otpSent,
    String? errorMessage,
    bool clearError = false,
    bool clearOtpSent = false,
  }) {
    return DeleteAccountState(
      status: status ?? this.status,
      otpSent: clearOtpSent ? null : (otpSent ?? this.otpSent),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, otpSent, errorMessage];
}
