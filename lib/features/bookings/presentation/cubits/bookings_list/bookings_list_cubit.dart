import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/booking_entity.dart';
import '../../../domain/repositories/bookings_repository.dart';

part 'bookings_list_state.dart';

final class BookingsListCubit extends Cubit<BookingsListState> {
  BookingsListCubit(this._repository) : super(const BookingsListState());

  final BookingsRepository _repository;

  Future<void> loadBookings({
    bool refresh = false,
    int limit = 10,
    String? sortOrder,
  }) async {
    emit(
      state.copyWith(
        status: BookingsListStatus.loading,
        errorMessage: null,
        bookings: refresh ? [] : state.bookings,
        page: 1,
        clearCheckInResult: true,
      ),
    );

    final result = await _repository.getBookings(
      page: 1,
      limit: limit,
      sortOrder: sortOrder,
    );

    result.fold(
      onSuccess: (page) => emit(
        state.copyWith(
          status: BookingsListStatus.loaded,
          bookings: page.items,
          page: page.page,
          totalPages: page.totalPages,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: BookingsListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> loadMore({int limit = 10, String? sortOrder}) async {
    if (!state.hasMore || state.isLoadingMore || state.isLoading) return;

    emit(state.copyWith(status: BookingsListStatus.loadingMore));

    final nextPage = state.page + 1;
    final result = await _repository.getBookings(
      page: nextPage,
      limit: limit,
      sortOrder: sortOrder,
    );

    result.fold(
      onSuccess: (page) => emit(
        state.copyWith(
          status: BookingsListStatus.loaded,
          bookings: [...state.bookings, ...page.items],
          page: page.page,
          totalPages: page.totalPages,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: BookingsListStatus.loaded,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<bool> cancelBooking(String id) async {
    emit(
      state.copyWith(
        status: BookingsListStatus.actionInProgress,
        actionBookingId: id,
        errorMessage: null,
      ),
    );

    final result = await _repository.cancelBooking(id);

    return result.when(
      success: (booking) {
        final updated = state.bookings
            .map((item) => item.id == id ? booking : item)
            .toList();
        emit(
          state.copyWith(
            status: BookingsListStatus.loaded,
            bookings: updated,
            clearActionBookingId: true,
          ),
        );
        return true;
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: BookingsListStatus.loaded,
            errorMessage: failure.message,
            clearActionBookingId: true,
          ),
        );
        return false;
      },
    );
  }

  Future<bool> checkInBooking(String id) async {
    emit(
      state.copyWith(
        status: BookingsListStatus.actionInProgress,
        actionBookingId: id,
        errorMessage: null,
        clearCheckInResult: true,
      ),
    );

    final result = await _repository.checkInBooking(id);

    return result.when(
      success: (checkInResult) async {
        final refresh = await _repository.getBookingById(id);
        refresh.fold(
          onSuccess: (booking) {
            final updated = state.bookings
                .map((item) => item.id == id ? booking : item)
                .toList();
            emit(
              state.copyWith(
                status: BookingsListStatus.loaded,
                bookings: updated,
                lastCheckInResult: checkInResult,
                clearActionBookingId: true,
              ),
            );
          },
          onFailure: (_) {
            emit(
              state.copyWith(
                status: BookingsListStatus.loaded,
                lastCheckInResult: checkInResult,
                clearActionBookingId: true,
              ),
            );
          },
        );
        return true;
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: BookingsListStatus.loaded,
            errorMessage: failure.message,
            clearActionBookingId: true,
          ),
        );
        return false;
      },
    );
  }

  void clearCheckInResult() {
    emit(state.copyWith(clearCheckInResult: true));
  }
}
