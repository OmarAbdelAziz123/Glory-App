part of 'inbody_history_cubit.dart';

enum InbodyHistoryStatus {
  initial,
  loading,
  refreshing,
  ready,
  loadingMore,
  failure,
}

final class InbodyHistoryState extends Equatable {
  const InbodyHistoryState({
    this.status = InbodyHistoryStatus.initial,
    this.summary,
    this.trends = const InbodyTrendsEntity(),
    this.tests = const [],
    this.page = 1,
    this.totalPages = 1,
    this.source,
    this.dateFrom,
    this.dateTo,
    this.errorMessage,
  });

  final InbodyHistoryStatus status;
  final InbodySummaryEntity? summary;
  final InbodyTrendsEntity trends;
  final List<InbodyTestEntity> tests;
  final int page;
  final int totalPages;
  final InbodySource? source;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? errorMessage;

  bool get isLoading => status == InbodyHistoryStatus.loading;
  bool get isRefreshing => status == InbodyHistoryStatus.refreshing;
  bool get isLoadingMore => status == InbodyHistoryStatus.loadingMore;
  bool get isEmpty => tests.isEmpty && (summary?.isEmpty ?? true);
  bool get hasMore => page < totalPages;
  bool get hasDateFilter => dateFrom != null || dateTo != null;

  InbodyHistoryState copyWith({
    InbodyHistoryStatus? status,
    InbodySummaryEntity? summary,
    InbodyTrendsEntity? trends,
    List<InbodyTestEntity>? tests,
    int? page,
    int? totalPages,
    InbodySource? source,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? errorMessage,
    bool clearError = false,
    bool clearSource = false,
    bool clearDates = false,
  }) {
    return InbodyHistoryState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      trends: trends ?? this.trends,
      tests: tests ?? this.tests,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      source: clearSource ? null : (source ?? this.source),
      dateFrom: clearDates ? null : (dateFrom ?? this.dateFrom),
      dateTo: clearDates ? null : (dateTo ?? this.dateTo),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        summary,
        trends,
        tests,
        page,
        totalPages,
        source,
        dateFrom,
        dateTo,
        errorMessage,
      ];
}
