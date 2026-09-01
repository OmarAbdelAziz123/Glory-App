part of 'coach_chat_unread_cubit.dart';

enum CoachChatUnreadStatus { initial, loading, loaded, failure }

final class CoachChatUnreadState extends Equatable {
  const CoachChatUnreadState({
    this.status = CoachChatUnreadStatus.initial,
    this.count = 0,
    this.errorMessage,
  });

  final CoachChatUnreadStatus status;
  final int count;
  final String? errorMessage;

  CoachChatUnreadState copyWith({
    CoachChatUnreadStatus? status,
    int? count,
    String? errorMessage,
  }) {
    return CoachChatUnreadState(
      status: status ?? this.status,
      count: count ?? this.count,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, count, errorMessage];
}
