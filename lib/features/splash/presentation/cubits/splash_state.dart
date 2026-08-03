part of 'splash_cubit.dart';

enum SplashStatus { initial, checking, authenticated, unauthenticated }

final class SplashState extends Equatable {
  const SplashState({this.status = SplashStatus.initial});

  final SplashStatus status;

  bool get isAuthenticated => status == SplashStatus.authenticated;

  SplashState copyWith({SplashStatus? status}) =>
      SplashState(status: status ?? this.status);

  @override
  List<Object?> get props => [status];
}
