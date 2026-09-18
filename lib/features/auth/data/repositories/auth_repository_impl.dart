import '../../../../core/result/result.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../../../core/utils/jwt_utils.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/member_entity.dart';
import '../../domain/entities/otp_sent_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_api_service.dart';
import '../mappers/auth_mappers.dart';
import '../models/complete_registration_request.dart';
import '../models/confirm_code_request.dart';
import '../models/forgot_password_request.dart';
import '../models/login_request.dart';
import '../models/logout_request.dart';
import '../models/refresh_token_request.dart';
import '../models/register_request.dart';
import '../models/reset_password_request.dart';
import '../models/resend_otp_request.dart';
import '../models/update_notifications_request.dart';
import '../models/verify_otp_request.dart';

final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote, this._secureStorage);

  final AuthRemoteApiService _remote;
  final ISecureStorage _secureStorage;

  @override
  Future<Result<OtpSentEntity>> register({
    required String fullName,
    required String phoneCountryCode,
    required String phone,
    required String email,
  }) async {
    final result = await _remote.register(
      RegisterRequest(
        fullName: fullName,
        phoneCountryCode: phoneCountryCode,
        phone: phone,
        email: email,
      ),
    );

    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<VerifyOtpEntity>> verifyOtp({
    required String email,
    required String purpose,
    required String code,
  }) async {
    final result = await _remote.verifyOtp(
      VerifyOtpRequest(email: email, purpose: purpose, code: code),
    );

    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<OtpSentEntity>> resendOtp({
    required String email,
    required String purpose,
  }) async {
    final result = await _remote.resendOtp(
      ResendOtpRequest(email: email, purpose: purpose),
    );

    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<OtpSentEntity>> forgotPassword({
    required String identifier,
  }) async {
    final result = await _remote.forgotPassword(
      ForgotPasswordRequest(identifier: identifier),
    );

    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<MemberEntity>> completeRegistration({
    required String otpToken,
    required String password,
    required String passwordConfirm,
  }) async {
    final result = await _remote.completeRegistration(
      CompleteRegistrationRequest(
        otpToken: otpToken,
        password: password,
        passwordConfirm: passwordConfirm,
      ),
    );

    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<String>> resetPassword({
    required String otpToken,
    required String password,
    required String passwordConfirm,
  }) async {
    final result = await _remote.resetPassword(
      ResetPasswordRequest(
        otpToken: otpToken,
        password: password,
        passwordConfirm: passwordConfirm,
      ),
    );

    return switch (result) {
      Success(:final data) => Success(data.message),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<AuthSessionEntity>> login({
    required String identifier,
    required String password,
  }) async {
    final result = await _remote.login(
      LoginRequest(identifier: identifier, password: password),
    );

    if (result case Success(:final data)) {
      final session = data.toEntity();
      await _persistSession(session);
      return Success(session);
    }

    return Failure((result as Failure).failure);
  }

  @override
  Future<Result<bool>> checkSession() async {
    final accessToken = await _secureStorage.read(StorageKeys.accessToken);
    final refreshToken = await _secureStorage.read(StorageKeys.refreshToken);

    final hasAccessToken = accessToken != null && accessToken.isNotEmpty;
    final hasRefreshToken = refreshToken != null && refreshToken.isNotEmpty;

    if (!hasAccessToken && !hasRefreshToken) {
      return const Success(false);
    }

    if (hasAccessToken && !JwtUtils.isExpired(accessToken)) {
      return const Success(true);
    }

    if (!hasRefreshToken) {
      await logout();
      return const Success(false);
    }

    final refreshResult = await _remote.refreshToken(
      RefreshTokenRequest(refreshToken: refreshToken),
    );

    if (refreshResult case Success(:final data)) {
      final session = data.toEntity();
      await _persistSession(session);
      return const Success(true);
    }

    await logout();
    return const Success(false);
  }

  @override
  Future<Result<MemberEntity>> getProfile() async {
    final result = await _remote.getProfile();

    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<bool>> updatePushNotifications({required bool enabled}) async {
    final result = await _remote.updatePushNotifications(
      UpdateNotificationsRequest(enabled: enabled),
    );

    return switch (result) {
      Success(:final data) => Success(data),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<void>> logout() async {
    final refreshToken = await _secureStorage.read(StorageKeys.refreshToken);

    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _remote.logout(LogoutRequest(refreshToken: refreshToken));
    }

    await _clearSession();
    return const Success(null);
  }

  @override
  Future<Result<OtpSentEntity>> requestDeleteAccount() async {
    final result = await _remote.requestDeleteAccount();

    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<void>> confirmDeleteAccount({required String code}) async {
    final result = await _remote.confirmDeleteAccount(
      ConfirmCodeRequest(code: code),
    );

    if (result case Success()) {
      await _clearSession();
      return const Success(null);
    }

    return Failure((result as Failure).failure);
  }

  Future<void> _clearSession() async {
    await _secureStorage.delete(StorageKeys.accessToken);
    await _secureStorage.delete(StorageKeys.refreshToken);
    await _secureStorage.delete(StorageKeys.userId);
  }

  Future<void> _persistSession(AuthSessionEntity session) async {
    await _secureStorage.write(
      StorageKeys.accessToken,
      session.accessToken,
    );
    await _secureStorage.write(
      StorageKeys.refreshToken,
      session.refreshToken,
    );
    await _secureStorage.write(StorageKeys.userId, session.member.id);
  }
}
