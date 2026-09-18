import 'package:dio/dio.dart';
import '../../../../core/l10n/fallback_messages.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/result/result.dart';
import '../models/onboarding_prefill_model.dart';
import '../models/onboarding_question_model.dart';
import '../models/onboarding_request.dart';
import '../models/onboarding_submit_request.dart';
import 'onboarding_api.dart';

final class OnboardingRemoteApiService extends ApiService {
  OnboardingRemoteApiService(super.dio, this._onboardingApi);

  final OnboardingApi _onboardingApi;

  Future<Result<OnboardingStatusModel>> getStatus() => _guard(() async {
        final response = await _onboardingApi.getStatus();
        if (!response.success || response.data == null) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return Success(response.data!);
      });

  Future<Result<List<OnboardingQuestionModel>>> getQuestions() =>
      _guard(() async {
        final response = await _onboardingApi.getQuestions();
        if (!response.success || response.data == null) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return Success(response.data!);
      });

  Future<Result<void>> submit(OnboardingSubmitRequest request) =>
      _submit(() => _onboardingApi.submit(request));

  Future<Result<void>> submitLegacy(OnboardingRequest request) =>
      _submit(() => _onboardingApi.submitLegacy(request));

  Future<Result<void>> _submit(
    Future<dynamic> Function() call,
  ) async {
    try {
      final response = await call();
      if (response.success != true) {
        return Failure(
          ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
        );
      }
      return const Success(null);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        return const Success(null);
      }
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

  Future<Result<String>> uploadPhoto(String filePath) async {
    try {
      final fileName = filePath.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
      });

      final response = await dio.post<Map<String, dynamic>>(
        Endpoints.mobileUploads,
        data: formData,
      );

      final body = response.data;
      if (body == null || body['success'] != true) {
        return Failure(
          ServerFailure(
            body?['message'] as String? ?? FallbackMessages.errorTryAgain,
          ),
        );
      }

      final data = body['data'];
      final url = switch (data) {
        final String value => value,
        final Map<String, dynamic> map =>
          map['url'] as String? ?? map['path'] as String?,
        _ => null,
      };

      if (url == null || url.isEmpty) {
        return Failure(ServerFailure(FallbackMessages.errorTryAgain));
      }

      return Success(url);
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
