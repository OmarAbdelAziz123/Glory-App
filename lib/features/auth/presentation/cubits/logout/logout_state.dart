part of 'logout_cubit.dart';

enum LogoutStatus { initial, loading, success, failure }

final class LogoutState extends Equatable {
  const LogoutState({
    this.status = LogoutStatus.initial,
    this.errorMessage,
  });

  final LogoutStatus status;
  final String? errorMessage;

  bool get isLoading => status == LogoutStatus.loading;

  LogoutState copyWith({
    LogoutStatus? status,
    String? errorMessage,
  }) =>
      LogoutState(
        status: status ?? this.status,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, errorMessage];
}
