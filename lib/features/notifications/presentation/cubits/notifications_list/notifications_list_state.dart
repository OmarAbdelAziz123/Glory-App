part of 'notifications_list_cubit.dart';

enum NotificationsListStatus {
  initial,
  loading,
  loaded,
  loadingMore,
  loadingDetail,
  failure,
}

final class NotificationsListState extends Equatable {
  const NotificationsListState({
    this.status = NotificationsListStatus.initial,
    this.notifications = const [],
    this.page = 1,
    this.totalPages = 1,
    this.errorMessage,
    this.selectedNotification,
  });

  final NotificationsListStatus status;
  final List<NotificationEntity> notifications;
  final int page;
  final int totalPages;
  final String? errorMessage;
  final NotificationEntity? selectedNotification;

  bool get isLoading => status == NotificationsListStatus.loading;
  bool get isLoadingMore => status == NotificationsListStatus.loadingMore;
  bool get hasMore => page < totalPages;

  NotificationsListState copyWith({
    NotificationsListStatus? status,
    List<NotificationEntity>? notifications,
    int? page,
    int? totalPages,
    String? errorMessage,
    NotificationEntity? selectedNotification,
    bool clearSelected = false,
  }) {
    return NotificationsListState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      errorMessage: errorMessage,
      selectedNotification: clearSelected
          ? null
          : (selectedNotification ?? this.selectedNotification),
    );
  }

  @override
  List<Object?> get props => [
        status,
        notifications,
        page,
        totalPages,
        errorMessage,
        selectedNotification,
      ];
}
