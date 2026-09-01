import 'package:flutter_test/flutter_test.dart';
import 'package:glory_gym/core/error/app_failure.dart';
import 'package:glory_gym/core/result/result.dart';
import 'package:glory_gym/features/checkin/data/mappers/checkin_mappers.dart';
import 'package:glory_gym/features/checkin/data/models/qr_generate_model.dart';
import 'package:glory_gym/features/checkin/data/models/qr_status_model.dart';
import 'package:glory_gym/features/checkin/domain/entities/qr_session_entity.dart';
import 'package:glory_gym/features/checkin/domain/repositories/checkin_repository.dart';
import 'package:glory_gym/features/checkin/presentation/cubits/gym_qr/gym_qr_cubit.dart';

import '../../helpers/fixtures.dart';

final class _FakeCheckinRepository implements CheckinRepository {
  _FakeCheckinRepository({
    this.generateResult,
    this.statusResults = const [],
  });

  final Result<QrSessionEntity>? generateResult;
  final List<Result<QrStatusEntity>> statusResults;
  int statusCallCount = 0;

  @override
  Future<Result<QrSessionEntity>> generateQr() async {
    return generateResult ??
        Success(
          QrGenerateModel.fromJson(qrGenerateJson).toEntity(),
        );
  }

  @override
  Future<Result<QrStatusEntity>> getQrStatus(String id) async {
    if (statusResults.isEmpty) {
      return Success(QrStatusModel.fromJson(qrStatusPendingJson).toEntity());
    }
    final index = statusCallCount.clamp(0, statusResults.length - 1);
    statusCallCount++;
    return statusResults[index];
  }

  @override
  Future<Result<QrStatusEntity>> scanQr(String token) async {
    return Success(QrStatusModel.fromJson(qrStatusConsumedJson).toEntity());
  }
}

void main() {
  group('Check-in models', () {
    test('parses QR generate response', () {
      final model = QrGenerateModel.fromJson(qrGenerateJson);

      expect(model.id, 'cm123');
      expect(model.token, 'b6f2-uuid-token');
      expect(model.expiresInSeconds, 20);
    });

    test('maps QR statuses correctly', () {
      final pending = QrStatusModel.fromJson(qrStatusPendingJson).toEntity();
      final consumed = QrStatusModel.fromJson(qrStatusConsumedJson).toEntity();

      expect(pending.status, QrSessionStatus.pending);
      expect(consumed.status, QrSessionStatus.consumed);
      expect(consumed.daysRemaining, 12);
    });
  });

  group('GymQrCubit', () {
    test('generateQr uses token and expiresInSeconds from API', () async {
      final cubit = GymQrCubit(_FakeCheckinRepository());

      await cubit.generateQr();

      expect(cubit.state.status, GymQrStatus.active);
      expect(cubit.state.qrToken, 'b6f2-uuid-token');
      expect(cubit.state.qrId, 'cm123');
      expect(cubit.state.secondsLeft, 20);

      await cubit.close();
    });

    test('generateQr surfaces failure', () async {
      final cubit = GymQrCubit(
        _FakeCheckinRepository(
          generateResult: const Failure(ServerFailure('network error')),
        ),
      );

      await cubit.generateQr();

      expect(cubit.state.status, GymQrStatus.failure);
      expect(cubit.state.errorMessage, 'network error');

      await cubit.close();
    });
  });
}
