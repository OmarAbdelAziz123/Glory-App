import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/l10n/fallback_messages.dart';
import '../../../domain/entities/sandy_entities.dart';
import '../../../domain/repositories/sandy_repository.dart';

part 'sandy_chat_state.dart';

final class SandyChatCubit extends Cubit<SandyChatState> {
  SandyChatCubit(this._repository) : super(const SandyChatState());

  static const int _pageSize = 30;
  static const int maxMessageLength = 2000;

  final SandyRepository _repository;
  int _pendingCounter = 0;

  Future<void> initialize() async {
    if (state.status != SandyChatStatus.initial) return;

    emit(
      state.copyWith(
        status: SandyChatStatus.loading,
        clearError: true,
      ),
    );

    final lang = LocaleHolder.languageCode;
    final suggestionsResult = await _repository.getSuggestions(lang: lang);

    var suggestions = <String>[];
    suggestionsResult.fold(
      onSuccess: (data) => suggestions = data,
      onFailure: (_) {},
    );

    emit(
      state.copyWith(
        status: SandyChatStatus.loaded,
        suggestions: suggestions,
        showSuggestions: true,
      ),
    );
  }

  Future<void> openConversation(String conversationId) async {
    emit(
      state.copyWith(
        status: SandyChatStatus.loading,
        clearError: true,
        showSuggestions: false,
      ),
    );

    final result = await _repository.getMessages(
      conversationId: conversationId,
      page: 1,
      limit: _pageSize,
    );

    result.fold(
      onSuccess: (messagesPage) => emit(
        state.copyWith(
          status: SandyChatStatus.loaded,
          conversationId: conversationId,
          messages: messagesPage.items,
          page: messagesPage.page,
          totalPages: messagesPage.totalPages,
          showSuggestions: false,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: SandyChatStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  void startNewConversation() {
    emit(
      state.copyWith(
        status: SandyChatStatus.loaded,
        clearConversationId: true,
        messages: const [],
        page: 1,
        totalPages: 1,
        showSuggestions: true,
        clearError: true,
        clearLastFailedMessage: true,
      ),
    );
  }

  Future<void> loadOlderMessages() async {
    final conversationId = state.conversationId;
    if (conversationId == null ||
        !state.hasMore ||
        state.isLoadingMore ||
        state.isLoading) {
      return;
    }

    emit(state.copyWith(status: SandyChatStatus.loadingMore));

    final nextPage = state.page + 1;
    final result = await _repository.getMessages(
      conversationId: conversationId,
      page: nextPage,
      limit: _pageSize,
    );

    result.fold(
      onSuccess: (page) {
        emit(
          state.copyWith(
            status: SandyChatStatus.loaded,
            messages: [...page.items, ...state.messages],
            page: page.page,
            totalPages: page.totalPages,
          ),
        );
      },
      onFailure: (_) => emit(state.copyWith(status: SandyChatStatus.loaded)),
    );
  }

  Future<void> sendMessage(String body) async {
    final trimmed = body.trim();
    if (trimmed.isEmpty ||
        trimmed.length > maxMessageLength ||
        state.isTyping) {
      return;
    }

    final pendingUserMessage = SandyMessageEntity(
      id: 'pending_user_${++_pendingCounter}',
      body: trimmed,
      role: SandyMessageRole.user,
      createdAt: DateTime.now(),
    );

    emit(
      state.copyWith(
        status: SandyChatStatus.sending,
        messages: [...state.messages, pendingUserMessage],
        showSuggestions: false,
        clearError: true,
        clearLastFailedMessage: true,
      ),
    );

    final result = await _repository.sendMessage(
      message: trimmed,
      conversationId: state.conversationId,
    );

    result.fold(
      onSuccess: (chatResult) {
        final withoutPending = state.messages
            .where((message) => message.id != pendingUserMessage.id)
            .toList();

        final confirmedUser = SandyMessageEntity(
          id: pendingUserMessage.id.replaceFirst('pending_', 'local_'),
          body: trimmed,
          role: SandyMessageRole.user,
          createdAt: pendingUserMessage.createdAt,
        );

        final assistant = chatResult.message;
        final showSuggestions =
            assistant.refusalReason == SandyRefusalReason.outOfScope;

        emit(
          state.copyWith(
            status: SandyChatStatus.loaded,
            conversationId: chatResult.conversationId,
            messages: [...withoutPending, confirmedUser, assistant],
            showSuggestions: showSuggestions,
            lastFailedMessage:
                assistant.refusalReason == SandyRefusalReason.providerError
                    ? trimmed
                    : null,
            clearLastFailedMessage:
                assistant.refusalReason != SandyRefusalReason.providerError,
          ),
        );
      },
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: SandyChatStatus.loaded,
            messages: state.messages
                .where((message) => message.id != pendingUserMessage.id)
                .toList(),
            errorMessage: failure.message,
            lastFailedMessage: trimmed,
          ),
        );
      },
    );
  }

  Future<void> retryLastMessage() async {
    final message = state.lastFailedMessage;
    if (message == null) return;
    await sendMessage(message);
  }

  void dismissSuggestions() {
    if (!state.showSuggestions) return;
    emit(state.copyWith(showSuggestions: false));
  }
}
