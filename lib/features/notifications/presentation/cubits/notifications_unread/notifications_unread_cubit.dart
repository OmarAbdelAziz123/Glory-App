import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/notifications_repository.dart';

part 'notifications_unread_state.dart';

final class NotificationsUnreadCubit extends Cubit<NotificationsUnreadState> {
  NotificationsUnreadCubit(this._repository)
      : super(const NotificationsUnreadState());

  final NotificationsRepository _repository;

  Future<void> fetchUnreadCount() async {
    emit(
      state.copyWith(
        status: NotificationsUnreadStatus.loading,
        errorMessage: null,
      ),
    );

    final result = await _repository.getUnreadCount();

    result.fold(
      onSuccess: (count) => emit(
        state.copyWith(
          status: NotificationsUnreadStatus.loaded,
          count: count,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: NotificationsUnreadStatus.loaded,
          count: 0,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  void decrement() {
    if (state.count <= 0) return;
    emit(state.copyWith(count: state.count - 1));
  }

  void resetCount() {
    emit(state.copyWith(count: 0));
  }
}
