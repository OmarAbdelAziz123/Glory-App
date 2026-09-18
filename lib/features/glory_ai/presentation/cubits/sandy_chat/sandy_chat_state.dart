part of 'sandy_chat_cubit.dart';

enum SandyChatStatus {
  initial,
  loading,
  loaded,
  sending,
  streaming,
  loadingMore,
  failure,
}

final class SandyChatState extends Equatable {
  const SandyChatState({
    this.status = SandyChatStatus.initial,
    this.messages = const [],
    this.suggestions = const [],
    this.conversationId,
    this.page = 1,
    this.totalPages = 1,
    this.showSuggestions = false,
    this.errorMessage,
    this.lastFailedMessage,
    this.hasTrainingCaution = false,
  });

  final SandyChatStatus status;
  final List<SandyMessageEntity> messages;
  final List<String> suggestions;
  final String? conversationId;
  final int page;
  final int totalPages;
  final bool showSuggestions;
  final String? errorMessage;
  final String? lastFailedMessage;
  final bool hasTrainingCaution;

  bool get isTyping => status == SandyChatStatus.sending;
  bool get isStreaming => status == SandyChatStatus.streaming;
  bool get isBusy => isTyping || isStreaming;
  bool get isLoading => status == SandyChatStatus.loading;
  bool get isLoadingMore => status == SandyChatStatus.loadingMore;
  bool get hasMore => page < totalPages;
  bool get isEmpty => messages.isEmpty;

  SandyChatState copyWith({
    SandyChatStatus? status,
    List<SandyMessageEntity>? messages,
    List<String>? suggestions,
    String? conversationId,
    int? page,
    int? totalPages,
    bool? showSuggestions,
    String? errorMessage,
    String? lastFailedMessage,
    bool? hasTrainingCaution,
    bool clearError = false,
    bool clearLastFailedMessage = false,
    bool clearConversationId = false,
  }) {
    return SandyChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      suggestions: suggestions ?? this.suggestions,
      conversationId:
          clearConversationId ? null : (conversationId ?? this.conversationId),
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      showSuggestions: showSuggestions ?? this.showSuggestions,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastFailedMessage: clearLastFailedMessage
          ? null
          : (lastFailedMessage ?? this.lastFailedMessage),
      hasTrainingCaution: hasTrainingCaution ?? this.hasTrainingCaution,
    );
  }

  @override
  List<Object?> get props => [
        status,
        messages,
        suggestions,
        conversationId,
        page,
        totalPages,
        showSuggestions,
        errorMessage,
        lastFailedMessage,
        hasTrainingCaution,
      ];
}
