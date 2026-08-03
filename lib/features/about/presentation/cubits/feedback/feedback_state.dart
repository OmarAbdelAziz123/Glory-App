part of 'feedback_cubit.dart';

enum FeedbackStatus { initial, submitting, success, failure }

final class FeedbackState extends Equatable {
  const FeedbackState({
    this.status = FeedbackStatus.initial,
    this.errorMessage,
  });

  final FeedbackStatus status;
  final String? errorMessage;

  bool get isSubmitting => status == FeedbackStatus.submitting;

  FeedbackState copyWith({
    FeedbackStatus? status,
    String? errorMessage,
  }) =>
      FeedbackState(
        status: status ?? this.status,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, errorMessage];
}
