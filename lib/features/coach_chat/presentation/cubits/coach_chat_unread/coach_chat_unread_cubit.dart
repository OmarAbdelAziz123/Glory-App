import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/chat_entities.dart';
import '../../../domain/repositories/coach_chat_repository.dart';

part 'coach_chat_unread_state.dart';

final class CoachChatUnreadCubit extends Cubit<CoachChatUnreadState> {
  CoachChatUnreadCubit(this._repository)
      : super(const CoachChatUnreadState()) {
    _messageSub = _repository.watchIncomingMessages().listen((_) {
      fetchUnreadCount();
    });
  }

  final CoachChatRepository _repository;
  late final StreamSubscription<ChatMessageEntity> _messageSub;

  Future<void> fetchUnreadCount() async {
    emit(
      state.copyWith(
        status: CoachChatUnreadStatus.loading,
        errorMessage: null,
      ),
    );

    final result = await _repository.getUnreadCount();

    result.fold(
      onSuccess: (count) => emit(
        state.copyWith(
          status: CoachChatUnreadStatus.loaded,
          count: count,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: CoachChatUnreadStatus.loaded,
          count: 0,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  void resetCount() {
    emit(state.copyWith(count: 0));
  }

  @override
  Future<void> close() {
    _messageSub.cancel();
    return super.close();
  }
}
