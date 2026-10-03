part of 'booking_detail_cubit.dart';

enum BookingDetailStatus { initial, loading, loaded, failure }

final class BookingDetailState extends Equatable {
  const BookingDetailState({
    this.status = BookingDetailStatus.initial,
    this.booking,
    this.rating,
    this.errorMessage,
    this.isActionInProgress = false,
  });

  final BookingDetailStatus status;
  final BookingEntity? booking;
  final BookingRatingEntity? rating;
  final String? errorMessage;
  final bool isActionInProgress;

  BookingDetailState copyWith({
    BookingDetailStatus? status,
    BookingEntity? booking,
    BookingRatingEntity? rating,
    String? errorMessage,
    bool? isActionInProgress,
  }) {
    return BookingDetailState(
      status: status ?? this.status,
      booking: booking ?? this.booking,
      rating: rating ?? this.rating,
      errorMessage: errorMessage,
      isActionInProgress: isActionInProgress ?? this.isActionInProgress,
    );
  }

  @override
  List<Object?> get props => [
        status,
        booking,
        rating,
        errorMessage,
        isActionInProgress,
      ];
}
