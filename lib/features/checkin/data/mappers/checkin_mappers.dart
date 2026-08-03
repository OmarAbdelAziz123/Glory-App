import '../../domain/entities/qr_session_entity.dart';
import '../models/qr_generate_model.dart';
import '../models/qr_status_model.dart';

extension QrGenerateModelX on QrGenerateModel {
  QrSessionEntity toEntity() => QrSessionEntity(
        id: id,
        token: token,
        expiresAt: expiresAt,
        expiresInSeconds: expiresInSeconds,
      );
}

extension QrStatusModelX on QrStatusModel {
  QrStatusEntity toEntity() => QrStatusEntity(
        id: id,
        status: switch (status) {
          'CONSUMED' => QrSessionStatus.consumed,
          'EXPIRED' => QrSessionStatus.expired,
          _ => QrSessionStatus.pending,
        },
        expiresAt: expiresAt,
        daysRemaining: daysRemaining,
      );
}
