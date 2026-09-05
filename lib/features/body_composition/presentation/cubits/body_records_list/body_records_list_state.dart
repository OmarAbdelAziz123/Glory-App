part of 'body_records_list_cubit.dart';

enum BodyRecordsListStatus {
  initial,
  loading,
  loaded,
  loadingMore,
  failure,
}

final class BodyRecordsListState extends Equatable {
  const BodyRecordsListState({
    this.status = BodyRecordsListStatus.initial,
    this.records = const [],
    this.page = 1,
    this.totalPages = 1,
    this.errorMessage,
  });

  final BodyRecordsListStatus status;
  final List<BodyRecordEntity> records;
  final int page;
  final int totalPages;
  final String? errorMessage;

  bool get isLoading => status == BodyRecordsListStatus.loading;
  bool get isLoadingMore => status == BodyRecordsListStatus.loadingMore;
  bool get isEmpty => records.isEmpty && !isLoading;
  bool get hasMore => page < totalPages;

  BodyRecordsListState copyWith({
    BodyRecordsListStatus? status,
    List<BodyRecordEntity>? records,
    int? page,
    int? totalPages,
    String? errorMessage,
  }) {
    return BodyRecordsListState(
      status: status ?? this.status,
      records: records ?? this.records,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, records, page, totalPages, errorMessage];
}
