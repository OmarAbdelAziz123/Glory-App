import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/l10n/fallback_messages.dart';
import '../../../../../core/result/result.dart';
import '../../../domain/entities/sandy_entities.dart';
import '../../../domain/repositories/sandy_repository.dart';

part 'sandy_chat_state.dart';

final class SandyChatCubit extends Cubit<SandyChatState> {
  SandyChatCubit(this._repository) : super(const SandyChatState());

  static const int _pageSize = 30;
  static const int maxMessageLength = 2000;
  static const int maxFileBytes = 15 * 1024 * 1024;
  static const _imageExtensions = {
    'jpg',
    'jpeg',
    'png',
    'webp',
    'heic',
    'heif',
  };

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
    await refreshTrainingCaution();
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
        state.isBusy) {
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

    var started = false;
    var assembled = '';
    final streamingId = 'streaming_$_pendingCounter';

    final streamResult = await _repository.streamMessage(
      message: trimmed,
      conversationId: state.conversationId,
      onDelta: (chunk) {
        if (isClosed) return;
        assembled += chunk;
        if (!started) {
          started = true;
          emit(
            state.copyWith(
              status: SandyChatStatus.streaming,
              messages: [
                ...state.messages,
                SandyMessageEntity(
                  id: streamingId,
                  body: assembled,
                  role: SandyMessageRole.assistant,
                  createdAt: DateTime.now(),
                ),
              ],
            ),
          );
          return;
        }

        emit(
          state.copyWith(
            messages: [
              for (final message in state.messages)
                if (message.id == streamingId)
                  message.copyWith(body: assembled)
                else
                  message,
            ],
          ),
        );
      },
    );

    if (isClosed) return;

    if (streamResult is Failure && !started) {
      await _completeNonStreamedReply(
        trimmed: trimmed,
        pendingUserMessage: pendingUserMessage,
      );
      return;
    }

    streamResult.fold(
      onSuccess: (chatResult) => _finishAssistantReply(
        trimmed: trimmed,
        pendingUserMessage: pendingUserMessage,
        streamingId: streamingId,
        chatResult: chatResult,
        fallbackBody: assembled,
      ),
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: SandyChatStatus.loaded,
            messages: state.messages
                .where(
                  (message) =>
                      message.id != pendingUserMessage.id &&
                      message.id != streamingId,
                )
                .toList(),
            errorMessage: failure.message,
            lastFailedMessage: trimmed,
          ),
        );
      },
    );
  }

  Future<void> _completeNonStreamedReply({
    required String trimmed,
    required SandyMessageEntity pendingUserMessage,
  }) async {
    final result = await _repository.sendMessage(
      message: trimmed,
      conversationId: state.conversationId,
    );

    if (isClosed) return;

    result.fold(
      onSuccess: (chatResult) => _finishAssistantReply(
        trimmed: trimmed,
        pendingUserMessage: pendingUserMessage,
        streamingId: null,
        chatResult: chatResult,
      ),
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

  void _finishAssistantReply({
    required String trimmed,
    required SandyMessageEntity pendingUserMessage,
    required SandyChatResultEntity chatResult,
    String? streamingId,
    String? fallbackBody,
  }) {
    final withoutPending = state.messages
        .where(
          (message) =>
              message.id != pendingUserMessage.id && message.id != streamingId,
        )
        .toList();

    final confirmedUser = SandyMessageEntity(
      id: pendingUserMessage.id.replaceFirst('pending_', 'local_'),
      body: trimmed,
      role: SandyMessageRole.user,
      createdAt: pendingUserMessage.createdAt,
    );

    final assistant = chatResult.message.body.isNotEmpty
        ? chatResult.message
        : chatResult.message.copyWith(body: fallbackBody ?? '');
    final showSuggestions =
        assistant.refusalReason == SandyRefusalReason.outOfScope;

    emit(
      state.copyWith(
        status: SandyChatStatus.loaded,
        conversationId: chatResult.conversationId.isEmpty
            ? state.conversationId
            : chatResult.conversationId,
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
  }

  Future<void> retryLastMessage() async {
    final message = state.lastFailedMessage;
    if (message == null) return;
    await sendMessage(message);
  }

  Future<void> refreshTrainingCaution() async {
    final result = await _repository.getDocuments(page: 1, limit: 20);
    result.fold(
      onSuccess: (page) => emit(
        state.copyWith(
          hasTrainingCaution: page.items.any((doc) => doc.trainingCaution),
        ),
      ),
    );
  }

  Future<void> analyzeDocument({
    required String filePath,
    String? note,
  }) async {
    if (state.isBusy) return;

    final file = File(filePath);
    if (!file.existsSync()) {
      emit(state.copyWith(errorMessage: FallbackMessages.errorTryAgain));
      return;
    }

    final length = await file.length();
    if (length > maxFileBytes) {
      emit(state.copyWith(errorMessage: FallbackMessages.fileTooLarge));
      return;
    }

    final extension = filePath.split('.').last.toLowerCase();
    final isImage = _imageExtensions.contains(extension);
    final isPdf = extension == 'pdf';
    if (!isImage && !isPdf) {
      emit(state.copyWith(errorMessage: FallbackMessages.unsupportedFileType));
      return;
    }

    final trimmedNote = note?.trim();
    final pendingUserMessage = SandyMessageEntity(
      id: 'pending_doc_${++_pendingCounter}',
      body: (trimmedNote != null && trimmedNote.isNotEmpty)
          ? trimmedNote
          : FallbackMessages.sandyUploadedFile,
      role: SandyMessageRole.user,
      createdAt: DateTime.now(),
      attachmentUrl: filePath,
      attachmentLabel: filePath.split('/').last,
      attachmentIsImage: isImage,
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

    final result = await _repository.analyzeDocument(
      filePath: filePath,
      note: (trimmedNote != null && trimmedNote.isNotEmpty)
          ? trimmedNote
          : null,
      conversationId: state.conversationId,
      lang: LocaleHolder.languageCode,
    );

    result.fold(
      onSuccess: (analysis) {
        final withoutPending = state.messages
            .where((message) => message.id != pendingUserMessage.id)
            .toList();

        final confirmedUser = SandyMessageEntity(
          id: pendingUserMessage.id.replaceFirst('pending_', 'local_'),
          body: pendingUserMessage.body,
          role: SandyMessageRole.user,
          createdAt: pendingUserMessage.createdAt,
          attachmentUrl: pendingUserMessage.attachmentUrl,
          attachmentLabel: pendingUserMessage.attachmentLabel,
          attachmentIsImage: pendingUserMessage.attachmentIsImage,
        );

        final assistant = SandyMessageEntity(
          id: analysis.recordId,
          body: analysis.reply,
          role: SandyMessageRole.assistant,
          createdAt: DateTime.now(),
          flags: analysis.flags,
          trainingCaution: analysis.trainingCaution,
          isMedicalGuidance: true,
        );

        emit(
          state.copyWith(
            status: SandyChatStatus.loaded,
            messages: [...withoutPending, confirmedUser, assistant],
            hasTrainingCaution:
                state.hasTrainingCaution || analysis.trainingCaution,
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
          ),
        );
      },
    );
  }

  void dismissSuggestions() {
    if (!state.showSuggestions) return;
    emit(state.copyWith(showSuggestions: false));
  }
}
