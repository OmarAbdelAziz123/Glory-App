part of 'notifications_unread_cubit.dart';

enum NotificationsUnreadStatus { initial, loading, loaded, failure }

final class NotificationsUnreadState extends Equatable {
  const NotificationsUnreadState({
    this.status = NotificationsUnreadStatus.initial,
    this.count = 0,
    this.errorMessage,
  });

  final NotificationsUnreadStatus status;
  final int count;
  final String? errorMessage;

  NotificationsUnreadState copyWith({
    NotificationsUnreadStatus? status,
    int? count,
    String? errorMessage,
  }) {
    return NotificationsUnreadState(
      status: status ?? this.status,
      count: count ?? this.count,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, count, errorMessage];
}
