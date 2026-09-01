part of 'coach_chat_list_cubit.dart';

enum CoachChatListStatus { initial, loading, refreshing, loaded, failure }

final class CoachChatListState extends Equatable {
  const CoachChatListState({
    this.status = CoachChatListStatus.initial,
    this.conversations = const [],
    this.errorMessage,
  });

  final CoachChatListStatus status;
  final List<ChatConversationEntity> conversations;
  final String? errorMessage;

  bool get isLoading => status == CoachChatListStatus.loading;
  bool get isEmpty => conversations.isEmpty;

  CoachChatListState copyWith({
    CoachChatListStatus? status,
    List<ChatConversationEntity>? conversations,
    String? errorMessage,
  }) {
    return CoachChatListState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, conversations, errorMessage];
}
