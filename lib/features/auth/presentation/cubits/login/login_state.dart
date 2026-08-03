part of 'login_cubit.dart';

enum LoginStatus { initial, loading, success, failure }

final class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
    this.session,
    this.errorMessage,
  });

  final LoginStatus status;
  final AuthSessionEntity? session;
  final String? errorMessage;

  bool get isLoading => status == LoginStatus.loading;

  LoginState copyWith({
    LoginStatus? status,
    AuthSessionEntity? session,
    String? errorMessage,
  }) =>
      LoginState(
        status: status ?? this.status,
        session: session ?? this.session,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, session, errorMessage];
}
