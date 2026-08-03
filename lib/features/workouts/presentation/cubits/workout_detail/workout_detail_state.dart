part of 'workout_detail_cubit.dart';

enum WorkoutDetailStatus {
  initial,
  loading,
  loaded,
  submittingWeight,
  failure,
}

final class WorkoutDetailState extends Equatable {
  const WorkoutDetailState({
    this.status = WorkoutDetailStatus.initial,
    this.detail,
    this.errorMessage,
  });

  final WorkoutDetailStatus status;
  final WorkoutAssignmentDetailEntity? detail;
  final String? errorMessage;

  bool get isLoading => status == WorkoutDetailStatus.loading;

  WorkoutDetailState copyWith({
    WorkoutDetailStatus? status,
    WorkoutAssignmentDetailEntity? detail,
    String? errorMessage,
  }) {
    return WorkoutDetailState(
      status: status ?? this.status,
      detail: detail ?? this.detail,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, detail, errorMessage];
}
