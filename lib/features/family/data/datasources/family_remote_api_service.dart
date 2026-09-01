import 'package:dio/dio.dart';
import '../../../../core/l10n/fallback_messages.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/result/result.dart';
import '../models/family_api_responses.dart';
import '../models/add_family_member_request.dart';
import '../models/family_member_model.dart';
import '../models/update_family_member_request.dart';
import 'family_api.dart';

final class FamilyRemoteApiService extends ApiService {
  FamilyRemoteApiService(super.dio, this._familyApi);

  final FamilyApi _familyApi;

  Future<Result<FamilyMembersApiResponse>> getFamilyMembers({
    int page = 1,
    int limit = 10,
  }) =>
      _guard(() async {
        final response = await _familyApi.getFamilyMembers(
          page: page,
          limit: limit,
        );
        if (!response.success) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return Success(response);
      });

  Future<Result<FamilyMemberModel>> addFamilyMember(
    AddFamilyMemberRequest request,
  ) =>
      _guard(() async => _mapMemberResponse(
            await _familyApi.addFamilyMember(request),
          ));

  Future<Result<FamilyMemberModel>> updateFamilyMember({
    required String id,
    required UpdateFamilyMemberRequest request,
  }) =>
      _guard(() async => _mapMemberResponse(
            await _familyApi.updateFamilyMember(id, request),
          ));

  Future<Result<void>> deleteFamilyMember(String id) => _guard(() async {
        final response = await _familyApi.deleteFamilyMember(id);
        if (!response.success) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return const Success(null);
      });

  Result<FamilyMemberModel> _mapMemberResponse(FamilyMemberApiResponse response) {
    if (!response.success || response.data == null) {
      return Failure(
        ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
      );
    }
    return Success(response.data!);
  }

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
            NetworkFailure(FallbackMessages.noInternet),
          _ => ServerFailure(e.message ?? FallbackMessages.errorGeneral),
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
