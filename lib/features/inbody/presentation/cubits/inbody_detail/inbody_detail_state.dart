part of 'inbody_detail_cubit.dart';

enum InbodyDetailStatus { initial, loading, ready, failure }

final class InbodyDetailState extends Equatable {
  const InbodyDetailState({
    this.status = InbodyDetailStatus.initial,
    this.test,
    this.errorMessage,
  });

  final InbodyDetailStatus status;
  final InbodyTestEntity? test;
  final String? errorMessage;

  bool get isLoading => status == InbodyDetailStatus.loading;

  InbodyDetailState copyWith({
    InbodyDetailStatus? status,
    InbodyTestEntity? test,
    String? errorMessage,
    bool clearError = false,
  }) {
    return InbodyDetailState(
      status: status ?? this.status,
      test: test ?? this.test,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, test, errorMessage];
}
