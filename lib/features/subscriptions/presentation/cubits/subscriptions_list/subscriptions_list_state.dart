part of 'subscriptions_list_cubit.dart';

enum SubscriptionsListStatus { initial, loading, loaded, loadingMore, failure }

final class SubscriptionsListState extends Equatable {
  const SubscriptionsListState({
    this.status = SubscriptionsListStatus.initial,
    this.subscriptions = const [],
    this.page = 1,
    this.totalPages = 1,
    this.errorMessage,
  });

  final SubscriptionsListStatus status;
  final List<SubscriptionEntity> subscriptions;
  final int page;
  final int totalPages;
  final String? errorMessage;

  bool get isLoading => status == SubscriptionsListStatus.loading;
  bool get isLoadingMore => status == SubscriptionsListStatus.loadingMore;
  bool get isEmpty => subscriptions.isEmpty && !isLoading;
  bool get hasMore => page < totalPages;

  SubscriptionsListState copyWith({
    SubscriptionsListStatus? status,
    List<SubscriptionEntity>? subscriptions,
    int? page,
    int? totalPages,
    String? errorMessage,
  }) {
    return SubscriptionsListState(
      status: status ?? this.status,
      subscriptions: subscriptions ?? this.subscriptions,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        subscriptions,
        page,
        totalPages,
        errorMessage,
      ];
}
