part of 'gym_qr_cubit.dart';

enum GymQrStatus {
  initial,
  generating,
  active,
  expired,
  consumed,
  failure,
}

final class GymQrState extends Equatable {
  const GymQrState({
    this.status = GymQrStatus.initial,
    this.qrToken,
    this.qrId,
    this.secondsLeft = 0,
    this.daysRemaining,
    this.errorMessage,
  });

  final GymQrStatus status;
  final String? qrToken;
  final String? qrId;
  final int secondsLeft;
  final int? daysRemaining;
  final String? errorMessage;

  bool get isGenerating => status == GymQrStatus.generating;
  bool get hasActiveQr =>
      status == GymQrStatus.active && qrToken != null && secondsLeft > 0;
  bool get canRegenerate =>
      status == GymQrStatus.initial ||
      status == GymQrStatus.expired ||
      status == GymQrStatus.consumed ||
      status == GymQrStatus.failure ||
      (status == GymQrStatus.active && secondsLeft <= 0);

  GymQrState copyWith({
    GymQrStatus? status,
    String? qrToken,
    String? qrId,
    int? secondsLeft,
    int? daysRemaining,
    String? errorMessage,
    bool clearDaysRemaining = false,
  }) {
    return GymQrState(
      status: status ?? this.status,
      qrToken: qrToken ?? this.qrToken,
      qrId: qrId ?? this.qrId,
      secondsLeft: secondsLeft ?? this.secondsLeft,
      daysRemaining:
          clearDaysRemaining ? null : (daysRemaining ?? this.daysRemaining),
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        qrToken,
        qrId,
        secondsLeft,
        daysRemaining,
        errorMessage,
      ];
}
