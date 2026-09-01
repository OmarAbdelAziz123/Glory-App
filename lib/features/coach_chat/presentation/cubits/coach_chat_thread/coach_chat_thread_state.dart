part of 'coach_chat_thread_cubit.dart';

enum CoachChatThreadStatus {
  initial,
  loading,
  refreshing,
  loadingMore,
  loaded,
  failure,
}

final class CoachChatThreadState extends Equatable {
  const CoachChatThreadState({
    this.status = CoachChatThreadStatus.initial,
    this.messages = const [],
    this.page = 1,
    this.totalPages = 1,
    this.errorMessage,
  });

  final CoachChatThreadStatus status;
  final List<ChatMessageEntity> messages;
  final int page;
  final int totalPages;
  final String? errorMessage;

  bool get isLoading => status == CoachChatThreadStatus.loading;
  bool get isLoadingMore => status == CoachChatThreadStatus.loadingMore;
  bool get hasMore => page < totalPages;

  CoachChatThreadState copyWith({
    CoachChatThreadStatus? status,
    List<ChatMessageEntity>? messages,
    int? page,
    int? totalPages,
    String? errorMessage,
  }) {
    return CoachChatThreadState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, messages, page, totalPages, errorMessage];
}
