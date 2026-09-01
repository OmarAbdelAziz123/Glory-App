import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/chat_entities.dart';
import '../../../domain/repositories/coach_chat_repository.dart';

part 'coach_chat_list_state.dart';

final class CoachChatListCubit extends Cubit<CoachChatListState> {
  CoachChatListCubit(this._repository) : super(const CoachChatListState()) {
    _messageSub = _repository.watchIncomingMessages().listen((_) {
      loadConversations(refresh: true);
    });
  }

  final CoachChatRepository _repository;
  late final StreamSubscription<ChatMessageEntity> _messageSub;

  Future<void> loadConversations({bool refresh = false}) async {
    emit(
      state.copyWith(
        status: refresh && state.conversations.isNotEmpty
            ? CoachChatListStatus.refreshing
            : CoachChatListStatus.loading,
        errorMessage: null,
        conversations: refresh ? state.conversations : const [],
      ),
    );

    final result = await _repository.getConversations();

    result.fold(
      onSuccess: (conversations) => emit(
        state.copyWith(
          status: CoachChatListStatus.loaded,
          conversations: conversations,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: CoachChatListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _messageSub.cancel();
    return super.close();
  }
}
