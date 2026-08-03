import 'package:dio/dio.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/result/result.dart';
import '../models/checkin_api_responses.dart';
import '../models/qr_generate_model.dart';
import '../models/qr_status_model.dart';
import 'checkin_api.dart';

final class CheckinRemoteApiService extends ApiService {
  CheckinRemoteApiService(super.dio, this._checkinApi);

  final CheckinApi _checkinApi;

  Future<Result<QrGenerateModel>> generateQr() => _guard(() async {
        final response = await _checkinApi.generateQr();
        if (!response.success || response.data == null) {
          return Failure(
            ServerFailure(response.message ?? 'حدث خطأ، حاول مرة أخرى'),
          );
        }
        return Success(response.data!);
      });

  Future<Result<QrStatusModel>> getQrStatus(String id) => _guard(() async {
        final response = await _checkinApi.getQrStatus(id);
        if (!response.success || response.data == null) {
          return Failure(
            ServerFailure(response.message ?? 'حدث خطأ، حاول مرة أخرى'),
          );
        }
        return Success(response.data!);
      });

  Future<Result<T>> _guard<T>(Future<Result<T>> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      final inner = e.error;
      if (inner is AppException) {
        return Failure(_mapException(inner));
      }
      return Failure(
        switch (e.type) {
          DioExceptionType.connectionTimeout ||
          DioExceptionType.receiveTimeout ||
          DioExceptionType.sendTimeout ||
          DioExceptionType.connectionError =>
            const NetworkFailure(),
          _ => ServerFailure(e.message ?? 'Unexpected error'),
        },
      );
    } on AppException catch (e) {
      return Failure(_mapException(e));
    } catch (e) {
      return Failure(ServerFailure(e.toString()));
    }
  }

  AppFailure _mapException(AppException e) => switch (e) {
        NetworkException() => NetworkFailure(e.message),
        UnauthorizedException() => UnauthorizedFailure(e.message),
        ServerException() => ServerFailure(e.message),
        CacheException() => CacheFailure(e.message),
        ValidationException() => ValidationFailure(e.message),
      };
}
