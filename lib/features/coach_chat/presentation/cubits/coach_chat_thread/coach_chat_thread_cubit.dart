import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/chat_entities.dart';
import '../../../domain/repositories/coach_chat_repository.dart';

part 'coach_chat_thread_state.dart';

final class CoachChatThreadCubit extends Cubit<CoachChatThreadState> {
  CoachChatThreadCubit(
    this._repository, {
    required this.conversationId,
    required this.instructorName,
    this.instructorAvatarUrl,
  }) : super(const CoachChatThreadState()) {
    _messageSub = _repository.watchIncomingMessages().listen(_onIncomingMessage);
  }

  static const int _pageSize = 30;
  static const int maxMessageLength = 2000;

  final CoachChatRepository _repository;
  final String conversationId;
  final String instructorName;
  final String? instructorAvatarUrl;

  late final StreamSubscription<ChatMessageEntity> _messageSub;
  int _pendingCounter = 0;

  Future<void> openThread() async {
    await Future.wait([
      loadMessages(refresh: true),
      _markAsRead(),
    ]);
  }

  Future<void> refreshMessages() => loadMessages(refresh: true);

  Future<void> loadMessages({bool refresh = false}) async {
    emit(
      state.copyWith(
        status: refresh && state.messages.isNotEmpty
            ? CoachChatThreadStatus.refreshing
            : CoachChatThreadStatus.loading,
        errorMessage: null,
        messages: refresh ? state.messages : const [],
        page: refresh ? 1 : state.page,
        totalPages: refresh ? 1 : state.totalPages,
      ),
    );

    final result = await _repository.getMessages(
      conversationId: conversationId,
      page: 1,
      limit: _pageSize,
    );

    result.fold(
      onSuccess: (page) {
        final chronological = page.items.reversed.toList();
        emit(
          state.copyWith(
            status: CoachChatThreadStatus.loaded,
            messages: _mergeWithPending(chronological),
            page: page.page,
            totalPages: page.totalPages,
          ),
        );
      },
      onFailure: (failure) => emit(
        state.copyWith(
          status: CoachChatThreadStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> loadOlderMessages() async {
    if (!state.hasMore || state.isLoadingMore || state.isLoading) return;

    emit(state.copyWith(status: CoachChatThreadStatus.loadingMore));

    final nextPage = state.page + 1;
    final result = await _repository.getMessages(
      conversationId: conversationId,
      page: nextPage,
      limit: _pageSize,
    );

    result.fold(
      onSuccess: (page) {
        final olderMessages = page.items.reversed.toList();
        emit(
          state.copyWith(
            status: CoachChatThreadStatus.loaded,
            messages: [...olderMessages, ...state.messages],
            page: page.page,
            totalPages: page.totalPages,
          ),
        );
      },
      onFailure: (failure) => emit(
        state.copyWith(
          status: CoachChatThreadStatus.loaded,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  void sendMessage(String body) {
    final trimmed = body.trim();
    if (trimmed.isEmpty || trimmed.length > maxMessageLength) return;

    final pending = ChatMessageEntity(
      id: 'pending_${++_pendingCounter}',
      conversationId: conversationId,
      senderType: ChatSenderType.member,
      sender: const ChatParticipantEntity(
        id: 'local-member',
        fullName: '',
      ),
      body: trimmed,
      read: true,
      createdAt: DateTime.now(),
      isPending: true,
    );

    emit(
      state.copyWith(
        messages: [...state.messages, pending],
        status: CoachChatThreadStatus.loaded,
      ),
    );

    _repository.sendMessage(
      conversationId: conversationId,
      body: trimmed,
    );
  }

  Future<void> _markAsRead() async {
    await _repository.markConversationAsRead(conversationId);
  }

  void _onIncomingMessage(ChatMessageEntity message) {
    if (message.conversationId != conversationId) return;

    final existingIndex =
        state.messages.indexWhere((item) => item.id == message.id);
    if (existingIndex >= 0) return;

    final updatedMessages = [...state.messages];

    if (message.isMember) {
      final pendingIndex = updatedMessages.lastIndexWhere(
        (item) =>
            item.isPending &&
            item.isMember &&
            item.body == message.body,
      );
      if (pendingIndex >= 0) {
        updatedMessages[pendingIndex] = message;
      } else {
        updatedMessages.add(message);
      }
    } else {
      updatedMessages.add(message);
    }

    emit(
      state.copyWith(
        messages: updatedMessages,
        status: CoachChatThreadStatus.loaded,
      ),
    );
  }

  List<ChatMessageEntity> _mergeWithPending(
    List<ChatMessageEntity> serverMessages,
  ) {
    final pending = state.messages.where((m) => m.isPending).toList();
    if (pending.isEmpty) return serverMessages;

    final merged = [...serverMessages];
    for (final item in pending) {
      final alreadyAcked = serverMessages.any(
        (message) =>
            message.isMember &&
            message.body == item.body &&
            message.createdAt.difference(item.createdAt).inSeconds.abs() < 30,
      );
      if (!alreadyAcked) merged.add(item);
    }
    return merged;
  }

  @override
  Future<void> close() {
    _messageSub.cancel();
    return super.close();
  }
}
