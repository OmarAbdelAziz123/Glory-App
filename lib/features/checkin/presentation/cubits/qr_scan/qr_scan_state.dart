part of 'qr_scan_cubit.dart';

enum QrScanStatus { initial, submitting, success, failure }

final class QrScanState extends Equatable {
  const QrScanState({
    this.status = QrScanStatus.initial,
    this.result,
    this.errorMessage,
  });

  final QrScanStatus status;
  final QrStatusEntity? result;
  final String? errorMessage;

  bool get isSubmitting => status == QrScanStatus.submitting;

  QrScanState copyWith({
    QrScanStatus? status,
    QrStatusEntity? result,
    String? errorMessage,
  }) {
    return QrScanState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, result, errorMessage];
}
