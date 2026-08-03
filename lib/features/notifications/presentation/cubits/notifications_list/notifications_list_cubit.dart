import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/notification_entity.dart';
import '../../../domain/repositories/notifications_repository.dart';

part 'notifications_list_state.dart';

final class NotificationsListCubit extends Cubit<NotificationsListState> {
  NotificationsListCubit(this._repository) : super(const NotificationsListState());

  final NotificationsRepository _repository;

  Future<void> loadNotifications({bool refresh = false}) async {
    emit(
      state.copyWith(
        status: NotificationsListStatus.loading,
        errorMessage: null,
        notifications: refresh ? [] : state.notifications,
        page: 1,
      ),
    );

    final result = await _repository.getNotifications(page: 1);

    result.fold(
      onSuccess: (page) => emit(
        state.copyWith(
          status: NotificationsListStatus.loaded,
          notifications: page.items,
          page: page.page,
          totalPages: page.totalPages,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: NotificationsListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore || state.isLoading) return;

    emit(state.copyWith(status: NotificationsListStatus.loadingMore));

    final nextPage = state.page + 1;
    final result = await _repository.getNotifications(page: nextPage);

    result.fold(
      onSuccess: (page) => emit(
        state.copyWith(
          status: NotificationsListStatus.loaded,
          notifications: [...state.notifications, ...page.items],
          page: page.page,
          totalPages: page.totalPages,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: NotificationsListStatus.loaded,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<NotificationEntity?> openNotification(String id) async {
    emit(state.copyWith(status: NotificationsListStatus.loadingDetail));

    final result = await _repository.getNotificationById(id);

    return result.when(
      success: (notification) {
        final updated = state.notifications
            .map(
              (item) => item.id == id
                  ? item.copyWith(isRead: true)
                  : item,
            )
            .toList();
        emit(
          state.copyWith(
            status: NotificationsListStatus.loaded,
            notifications: updated,
            selectedNotification: notification.copyWith(isRead: true),
          ),
        );
        return notification.copyWith(isRead: true);
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: NotificationsListStatus.loaded,
            errorMessage: failure.message,
          ),
        );
        return null;
      },
    );
  }

  void clearSelected() {
    emit(state.copyWith(clearSelected: true));
  }
}
