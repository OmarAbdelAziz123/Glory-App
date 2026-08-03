part of 'workouts_list_cubit.dart';

enum WorkoutsListStatus {
  initial,
  loading,
  loaded,
  loadingMore,
  failure,
}

final class WorkoutsListState extends Equatable {
  const WorkoutsListState({
    this.status = WorkoutsListStatus.initial,
    this.workouts = const [],
    this.page = 1,
    this.totalPages = 1,
    this.errorMessage,
  });

  final WorkoutsListStatus status;
  final List<WorkoutAssignmentEntity> workouts;
  final int page;
  final int totalPages;
  final String? errorMessage;

  bool get isLoading => status == WorkoutsListStatus.loading;
  bool get isLoadingMore => status == WorkoutsListStatus.loadingMore;
  bool get isEmpty => workouts.isEmpty && !isLoading;
  bool get hasMore => page < totalPages;

  WorkoutsListState copyWith({
    WorkoutsListStatus? status,
    List<WorkoutAssignmentEntity>? workouts,
    int? page,
    int? totalPages,
    String? errorMessage,
  }) {
    return WorkoutsListState(
      status: status ?? this.status,
      workouts: workouts ?? this.workouts,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, workouts, page, totalPages, errorMessage];
}
