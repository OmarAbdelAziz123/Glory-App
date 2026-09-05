import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/subscription_entity.dart';
import '../../../domain/repositories/subscriptions_repository.dart';

part 'subscriptions_list_state.dart';

final class SubscriptionsListCubit extends Cubit<SubscriptionsListState> {
  SubscriptionsListCubit(this._repository) : super(const SubscriptionsListState());

  final SubscriptionsRepository _repository;

  Future<void> loadSubscriptions({bool refresh = false, int limit = 10}) async {
    emit(
      state.copyWith(
        status: SubscriptionsListStatus.loading,
        errorMessage: null,
        subscriptions: refresh ? [] : state.subscriptions,
        page: 1,
      ),
    );

    final result = await _repository.getSubscriptions(page: 1, limit: limit);

    result.fold(
      onSuccess: (page) => emit(
        state.copyWith(
          status: SubscriptionsListStatus.loaded,
          subscriptions: page.items,
          page: page.page,
          totalPages: page.totalPages,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: SubscriptionsListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> loadMore({int limit = 10}) async {
    if (!state.hasMore || state.isLoadingMore || state.isLoading) return;

    emit(state.copyWith(status: SubscriptionsListStatus.loadingMore));

    final nextPage = state.page + 1;
    final result = await _repository.getSubscriptions(
      page: nextPage,
      limit: limit,
    );

    result.fold(
      onSuccess: (page) => emit(
        state.copyWith(
          status: SubscriptionsListStatus.loaded,
          subscriptions: [...state.subscriptions, ...page.items],
          page: page.page,
          totalPages: page.totalPages,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: SubscriptionsListStatus.loaded,
          errorMessage: failure.message,
        ),
      ),
    );
  }
}
