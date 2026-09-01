import '../../../../core/error/app_failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/qr_session_entity.dart';
import '../../domain/repositories/checkin_repository.dart';
import '../datasources/checkin_remote_api_service.dart';
import '../mappers/checkin_mappers.dart';

final class CheckinRepositoryImpl implements CheckinRepository {
  const CheckinRepositoryImpl(this._remote);

  final CheckinRemoteApiService _remote;

  @override
  Future<Result<QrSessionEntity>> generateQr() async {
    final result = await _remote.generateQr();
    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<QrStatusEntity>> getQrStatus(String id) async {
    final result = await _remote.getQrStatus(id);
    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<QrStatusEntity>> scanQr(String token) async {
    final result = await _remote.scanQr(token);
    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Failure(:final failure) => Failure(failure),
    };
  }
}
