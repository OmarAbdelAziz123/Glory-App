import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/body_measurement_entity.dart';
import '../../../domain/repositories/body_composition_repository.dart';

part 'body_records_list_state.dart';

final class BodyRecordsListCubit extends Cubit<BodyRecordsListState> {
  BodyRecordsListCubit(this._repository, {required this.type})
      : super(const BodyRecordsListState());

  final BodyCompositionRepository _repository;
  final String type;

  Future<void> loadRecords({bool refresh = false, int limit = 10}) async {
    emit(
      state.copyWith(
        status: BodyRecordsListStatus.loading,
        errorMessage: null,
        records: refresh ? [] : state.records,
        page: 1,
      ),
    );

    final result = await _repository.getBodyRecords(
      type: type,
      page: 1,
      limit: limit,
    );

    result.fold(
      onSuccess: (page) => emit(
        state.copyWith(
          status: BodyRecordsListStatus.loaded,
          records: page.items,
          page: page.page,
          totalPages: page.totalPages,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: BodyRecordsListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> loadMore({int limit = 10}) async {
    if (!state.hasMore || state.isLoadingMore || state.isLoading) return;

    emit(state.copyWith(status: BodyRecordsListStatus.loadingMore));

    final nextPage = state.page + 1;
    final result = await _repository.getBodyRecords(
      type: type,
      page: nextPage,
      limit: limit,
    );

    result.fold(
      onSuccess: (page) => emit(
        state.copyWith(
          status: BodyRecordsListStatus.loaded,
          records: [...state.records, ...page.items],
          page: page.page,
          totalPages: page.totalPages,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: BodyRecordsListStatus.loaded,
          errorMessage: failure.message,
        ),
      ),
    );
  }
}
