part of 'sandy_nudges_cubit.dart';

enum SandyNudgesStatus { initial, loading, loaded, updating, failure }

final class SandyNudgesState extends Equatable {
  const SandyNudgesState({
    this.status = SandyNudgesStatus.initial,
    this.enabled = true,
    this.errorMessage,
  });

  final SandyNudgesStatus status;
  final bool enabled;
  final String? errorMessage;

  bool get isLoading => status == SandyNudgesStatus.loading;
  bool get isUpdating => status == SandyNudgesStatus.updating;

  SandyNudgesState copyWith({
    SandyNudgesStatus? status,
    bool? enabled,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SandyNudgesState(
      status: status ?? this.status,
      enabled: enabled ?? this.enabled,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, enabled, errorMessage];
}
