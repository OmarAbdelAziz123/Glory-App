import '../error/app_failure.dart';

sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get dataOrNull => switch (this) {
        Success<T> s => s.data,
        Failure<T> _ => null,
      };

  AppFailure? get failureOrNull => switch (this) {
        Success<T> _ => null,
        Failure<T> f => f.failure,
      };

  R when<R>({
    required R Function(T data) success,
    required R Function(AppFailure failure) failure,
  }) =>
      switch (this) {
        Success<T> s => success(s.data),
        Failure<T> f => failure(f.failure),
      };

  void fold({
    void Function(T data)? onSuccess,
    void Function(AppFailure failure)? onFailure,
  }) {
    switch (this) {
      case Success<T> s:
        onSuccess?.call(s.data);
      case Failure<T> f:
        onFailure?.call(f.failure);
    }
  }
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

final class Failure<T> extends Result<T> {
  const Failure(this.failure);

  final AppFailure failure;
}
