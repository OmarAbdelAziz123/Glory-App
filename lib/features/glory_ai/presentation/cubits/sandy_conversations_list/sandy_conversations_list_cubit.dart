import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/sandy_entities.dart';
import '../../../domain/repositories/sandy_repository.dart';
import '../sandy_chat/sandy_chat_cubit.dart';

part 'sandy_conversations_list_state.dart';

final class SandyConversationsListCubit extends Cubit<SandyConversationsListState> {
  SandyConversationsListCubit(this._repository, this._chatCubit)
      : super(const SandyConversationsListState());

  final SandyRepository _repository;
  final SandyChatCubit _chatCubit;

  Future<void> loadConversations({bool refresh = false}) async {
    emit(
      state.copyWith(
        status: refresh && state.conversations.isNotEmpty
            ? SandyConversationsListStatus.refreshing
            : SandyConversationsListStatus.loading,
        clearError: true,
        conversations: refresh ? state.conversations : const [],
      ),
    );

    final result = await _repository.getConversations();

    result.fold(
      onSuccess: (conversations) => emit(
        state.copyWith(
          status: SandyConversationsListStatus.loaded,
          conversations: conversations,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: SandyConversationsListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<bool> openConversation(String conversationId) async {
    await _chatCubit.openConversation(conversationId);
    final chatState = _chatCubit.state;
    return chatState.status != SandyChatStatus.failure;
  }

  Future<void> renameConversation({
    required String conversationId,
    required String title,
  }) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;

    emit(
      state.copyWith(
        status: SandyConversationsListStatus.updating,
        clearActionError: true,
      ),
    );

    final result = await _repository.renameConversation(
      conversationId: conversationId,
      title: trimmed,
    );

    result.fold(
      onSuccess: (_) {
        final updated = state.conversations
            .map(
              (conversation) => conversation.id == conversationId
                  ? conversation.copyWith(title: trimmed)
                  : conversation,
            )
            .toList();

        emit(
          state.copyWith(
            status: SandyConversationsListStatus.loaded,
            conversations: updated,
          ),
        );
      },
      onFailure: (failure) => emit(
        state.copyWith(
          status: SandyConversationsListStatus.loaded,
          actionErrorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> deleteConversation(String conversationId) async {
    emit(
      state.copyWith(
        status: SandyConversationsListStatus.updating,
        clearActionError: true,
      ),
    );

    final result = await _repository.deleteConversation(conversationId);

    result.fold(
      onSuccess: (_) {
        if (_chatCubit.state.conversationId == conversationId) {
          _chatCubit.startNewConversation();
        }

        emit(
          state.copyWith(
            status: SandyConversationsListStatus.loaded,
            conversations: state.conversations
                .where((conversation) => conversation.id != conversationId)
                .toList(),
          ),
        );
      },
      onFailure: (failure) => emit(
        state.copyWith(
          status: SandyConversationsListStatus.loaded,
          actionErrorMessage: failure.message,
        ),
      ),
    );
  }
}
