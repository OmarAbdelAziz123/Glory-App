part of 'sandy_conversations_list_cubit.dart';

enum SandyConversationsListStatus {
  initial,
  loading,
  loaded,
  refreshing,
  updating,
  failure,
}

final class SandyConversationsListState extends Equatable {
  const SandyConversationsListState({
    this.status = SandyConversationsListStatus.initial,
    this.conversations = const [],
    this.errorMessage,
    this.actionErrorMessage,
  });

  final SandyConversationsListStatus status;
  final List<SandyConversationEntity> conversations;
  final String? errorMessage;
  final String? actionErrorMessage;

  bool get isLoading =>
      status == SandyConversationsListStatus.loading &&
      conversations.isEmpty;
  bool get isRefreshing => status == SandyConversationsListStatus.refreshing;
  bool get isUpdating => status == SandyConversationsListStatus.updating;
  bool get isEmpty => conversations.isEmpty;

  SandyConversationsListState copyWith({
    SandyConversationsListStatus? status,
    List<SandyConversationEntity>? conversations,
    String? errorMessage,
    String? actionErrorMessage,
    bool clearError = false,
    bool clearActionError = false,
  }) {
    return SandyConversationsListState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      actionErrorMessage: clearActionError
          ? null
          : (actionErrorMessage ?? this.actionErrorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        conversations,
        errorMessage,
        actionErrorMessage,
      ];
}
