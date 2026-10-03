import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/result/result.dart';
import '../../../domain/entities/booking_entity.dart';
import '../../../domain/repositories/bookings_repository.dart';

part 'booking_detail_state.dart';

final class BookingDetailCubit extends Cubit<BookingDetailState> {
  BookingDetailCubit(this._repository, {required this.bookingId})
      : super(const BookingDetailState());

  final BookingsRepository _repository;
  final String bookingId;

  Future<void> load() async {
    emit(state.copyWith(status: BookingDetailStatus.loading, errorMessage: null));

    final bookingResult = await _repository.getBookingById(bookingId);
    if (bookingResult case Failure(:final failure)) {
      emit(
        state.copyWith(
          status: BookingDetailStatus.failure,
          errorMessage: failure.message,
        ),
      );
      return;
    }

    final booking = (bookingResult as Success<BookingEntity>).data;
    BookingRatingEntity? rating;
    if (booking.checkedInAt != null && !booking.canRate) {
      final ratingResult = await _repository.getBookingRating(bookingId);
      ratingResult.fold(
        onSuccess: (value) => rating = value,
        onFailure: (_) {},
      );
    }

    emit(
      state.copyWith(
        status: BookingDetailStatus.loaded,
        booking: booking,
        rating: rating,
      ),
    );
  }

  Future<bool> cancel() async {
    emit(state.copyWith(isActionInProgress: true, errorMessage: null));
    final result = await _repository.cancelBooking(bookingId);
    return result.when(
      success: (booking) {
        emit(
          state.copyWith(
            isActionInProgress: false,
            booking: booking,
          ),
        );
        return true;
      },
      failure: (failure) {
        emit(
          state.copyWith(
            isActionInProgress: false,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
    );
  }

  Future<BookingCheckInResultEntity?> checkIn() async {
    emit(state.copyWith(isActionInProgress: true, errorMessage: null));
    final result = await _repository.checkInBooking(bookingId);
    return result.when(
      success: (checkIn) async {
        final refresh = await _repository.getBookingById(bookingId);
        refresh.fold(
          onSuccess: (booking) => emit(
            state.copyWith(
              isActionInProgress: false,
              booking: booking,
            ),
          ),
          onFailure: (_) => emit(state.copyWith(isActionInProgress: false)),
        );
        return checkIn;
      },
      failure: (failure) {
        emit(
          state.copyWith(
            isActionInProgress: false,
            errorMessage: failure.message,
          ),
        );
        return null;
      },
    );
  }

  void applyBooking(BookingEntity booking) {
    emit(state.copyWith(booking: booking));
  }
}
