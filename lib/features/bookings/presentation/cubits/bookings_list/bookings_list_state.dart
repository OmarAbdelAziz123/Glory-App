part of 'bookings_list_cubit.dart';

enum BookingsListStatus {
  initial,
  loading,
  loaded,
  loadingMore,
  actionInProgress,
  failure,
}

final class BookingsListState extends Equatable {
  const BookingsListState({
    this.status = BookingsListStatus.initial,
    this.bookings = const [],
    this.page = 1,
    this.totalPages = 1,
    this.errorMessage,
    this.actionBookingId,
    this.lastCheckInResult,
  });

  final BookingsListStatus status;
  final List<BookingEntity> bookings;
  final int page;
  final int totalPages;
  final String? errorMessage;
  final String? actionBookingId;
  final BookingCheckInResultEntity? lastCheckInResult;

  bool get isLoading => status == BookingsListStatus.loading;
  bool get isLoadingMore => status == BookingsListStatus.loadingMore;
  bool get isEmpty => bookings.isEmpty && !isLoading;
  bool get hasMore => page < totalPages;
  bool get isActionInProgress => status == BookingsListStatus.actionInProgress;

  BookingsListState copyWith({
    BookingsListStatus? status,
    List<BookingEntity>? bookings,
    int? page,
    int? totalPages,
    String? errorMessage,
    String? actionBookingId,
    BookingCheckInResultEntity? lastCheckInResult,
    bool clearActionBookingId = false,
    bool clearCheckInResult = false,
  }) {
    return BookingsListState(
      status: status ?? this.status,
      bookings: bookings ?? this.bookings,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      errorMessage: errorMessage,
      actionBookingId:
          clearActionBookingId ? null : (actionBookingId ?? this.actionBookingId),
      lastCheckInResult: clearCheckInResult
          ? null
          : (lastCheckInResult ?? this.lastCheckInResult),
    );
  }

  @override
  List<Object?> get props => [
        status,
        bookings,
        page,
        totalPages,
        errorMessage,
        actionBookingId,
        lastCheckInResult,
      ];
}
