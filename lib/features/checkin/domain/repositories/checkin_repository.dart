import '../../../../core/result/result.dart';
import '../entities/qr_session_entity.dart';

abstract interface class CheckinRepository {
  Future<Result<QrSessionEntity>> generateQr();

  Future<Result<QrStatusEntity>> getQrStatus(String id);
}
