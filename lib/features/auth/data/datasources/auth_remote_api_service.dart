import 'package:dio/dio.dart';
import '../../../../core/l10n/fallback_messages.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/result/result.dart';
import '../models/complete_registration_request.dart';
import '../models/forgot_password_request.dart';
import '../models/login_model.dart';
import '../models/login_request.dart';
import '../models/logout_request.dart';
import '../models/member_model.dart';
import '../models/otp_sent_model.dart';
import '../models/refresh_token_request.dart';
import '../models/register_request.dart';
import '../models/reset_password_model.dart';
import '../models/reset_password_request.dart';
import '../models/resend_otp_request.dart';
import '../models/update_notifications_request.dart';
import '../models/verify_otp_model.dart';
import '../models/verify_otp_request.dart';
import 'auth_api.dart';

final class AuthRemoteApiService extends ApiService {
  AuthRemoteApiService(super.dio, this._authApi);

  final AuthApi _authApi;

  Future<Result<OtpSentModel>> register(RegisterRequest request) => _guard(
        () async {
          final response = await _authApi.register(request);
          return _mapResponse(response.success, response.data, response.message);
        },
      );

  Future<Result<VerifyOtpModel>> verifyOtp(VerifyOtpRequest request) =>
      _guard(
        () async {
          final response = await _authApi.verifyOtp(request);
          return _mapResponse(response.success, response.data, response.message);
        },
      );

  Future<Result<OtpSentModel>> resendOtp(ResendOtpRequest request) => _guard(
        () async {
          final response = await _authApi.resendOtp(request);
          return _mapResponse(response.success, response.data, response.message);
        },
      );

  Future<Result<MemberModel>> completeRegistration(
    CompleteRegistrationRequest request,
  ) =>
      _guard(
        () async {
          final response = await _authApi.completeRegistration(request);
          return _mapResponse(response.success, response.data, response.message);
        },
      );

  Future<Result<LoginModel>> login(LoginRequest request) => _guard(
        () async {
          final response = await _authApi.login(request);
          return _mapResponse(response.success, response.data, response.message);
        },
      );

  Future<Result<LoginModel>> refreshToken(RefreshTokenRequest request) =>
      _guard(
        () async {
          final response = await _authApi.refreshToken(request);
          return _mapResponse(response.success, response.data, response.message);
        },
      );

  Future<Result<MemberModel>> getProfile() => _guard(
        () async {
          final response = await _authApi.getProfile();
          return _mapResponse(response.success, response.data, response.message);
        },
      );

  Future<Result<bool>> updatePushNotifications(
    UpdateNotificationsRequest request,
  ) =>
      _guard(
        () async {
          final response = await _authApi.updateNotifications(request);
          if (!response.success || response.data == null) {
            return Failure(
              ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
            );
          }
          return Success(response.data!.pushEnabled);
        },
      );

  Future<Result<OtpSentModel>> forgotPassword(ForgotPasswordRequest request) =>
      _guard(
        () async {
          final response = await _authApi.forgotPassword(request);
          return _mapResponse(response.success, response.data, response.message);
        },
      );

  Future<Result<ResetPasswordModel>> resetPassword(
    ResetPasswordRequest request,
  ) =>
      _guard(
        () async {
          final response = await _authApi.resetPassword(request);
          return _mapResponse(response.success, response.data, response.message);
        },
      );

  Future<Result<void>> logout(LogoutRequest request) => _guard(
        () async {
          final response = await _authApi.logout(request);
          if (!response.success) {
            return Failure(
              ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
            );
          }
          return const Success(null);
        },
      );

  Result<T> _mapResponse<T>(bool success, T? data, String? message) {
    if (!success || data == null) {
      return Failure(
        ServerFailure(message ?? FallbackMessages.errorTryAgain),
      );
    }
    return Success(data);
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
