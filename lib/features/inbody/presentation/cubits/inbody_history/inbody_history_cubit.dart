import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/result/result.dart';
import '../../../domain/entities/inbody_entities.dart';
import '../../../domain/repositories/inbody_repository.dart';

part 'inbody_history_state.dart';

final class InbodyHistoryCubit extends Cubit<InbodyHistoryState> {
  InbodyHistoryCubit(this._repository) : super(const InbodyHistoryState());

  static const _pageSize = 20;

  final InbodyRepository _repository;

  Future<void> load({bool refresh = false}) async {
    if (state.status == InbodyHistoryStatus.loading && !refresh) return;

    emit(
      state.copyWith(
        status: refresh && state.tests.isNotEmpty
            ? InbodyHistoryStatus.refreshing
            : InbodyHistoryStatus.loading,
        clearError: true,
      ),
    );

    final results = await Future.wait([
      _repository.getSummary(),
      _repository.getTrends(),
      _repository.getTests(
        page: 1,
        limit: _pageSize,
        source: state.source,
        dateFrom: state.dateFrom,
        dateTo: state.dateTo,
      ),
    ]);

    if (isClosed) return;

    final summaryResult = results[0] as Result<InbodySummaryEntity>;
    final trendsResult = results[1] as Result<InbodyTrendsEntity>;
    final pageResult = results[2] as Result<InbodyPageEntity>;

    if (pageResult is Failure<InbodyPageEntity> && state.tests.isEmpty) {
      emit(
        state.copyWith(
          status: InbodyHistoryStatus.failure,
          errorMessage: pageResult.failure.message,
        ),
      );
      return;
    }

    var summary = state.summary;
    summaryResult.fold(onSuccess: (data) => summary = data);

    var trends = state.trends;
    trendsResult.fold(onSuccess: (data) => trends = data);

    pageResult.fold(
      onSuccess: (page) {
        emit(
          state.copyWith(
            status: InbodyHistoryStatus.ready,
            summary: summary,
            trends: trends,
            tests: page.items,
            page: page.page,
            totalPages: page.totalPages,
            clearError: true,
          ),
        );
      },
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: InbodyHistoryStatus.ready,
            summary: summary,
            trends: trends,
            errorMessage: failure.message,
          ),
        );
      },
    );
  }

  Future<void> applyFilters({
    InbodySource? source,
    bool clearSource = false,
    DateTime? dateFrom,
    DateTime? dateTo,
    bool clearDates = false,
  }) async {
    emit(
      state.copyWith(
        source: clearSource ? null : (source ?? state.source),
        dateFrom: clearDates ? null : (dateFrom ?? state.dateFrom),
        dateTo: clearDates ? null : (dateTo ?? state.dateTo),
        clearSource: clearSource,
        clearDates: clearDates,
      ),
    );
    await load(refresh: true);
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore || state.isLoading) return;

    emit(state.copyWith(status: InbodyHistoryStatus.loadingMore));

    final result = await _repository.getTests(
      page: state.page + 1,
      limit: _pageSize,
      source: state.source,
      dateFrom: state.dateFrom,
      dateTo: state.dateTo,
    );

    if (isClosed) return;

    result.fold(
      onSuccess: (page) {
        emit(
          state.copyWith(
            status: InbodyHistoryStatus.ready,
            tests: [...state.tests, ...page.items],
            page: page.page,
            totalPages: page.totalPages,
          ),
        );
      },
      onFailure: (_) =>
          emit(state.copyWith(status: InbodyHistoryStatus.ready)),
    );
  }
}
