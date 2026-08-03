import '../../../../core/result/result.dart';
import '../entities/auth_session_entity.dart';
import '../entities/member_entity.dart';
import '../entities/otp_sent_entity.dart';

abstract interface class AuthRepository {
  Future<Result<OtpSentEntity>> register({
    required String fullName,
    required String phoneCountryCode,
    required String phone,
    required String email,
  });

  Future<Result<VerifyOtpEntity>> verifyOtp({
    required String email,
    required String purpose,
    required String code,
  });

  Future<Result<OtpSentEntity>> resendOtp({
    required String email,
    required String purpose,
  });

  Future<Result<OtpSentEntity>> forgotPassword({
    required String identifier,
  });

  Future<Result<MemberEntity>> completeRegistration({
    required String otpToken,
    required String password,
    required String passwordConfirm,
  });

  Future<Result<String>> resetPassword({
    required String otpToken,
    required String password,
    required String passwordConfirm,
  });

  Future<Result<AuthSessionEntity>> login({
    required String identifier,
    required String password,
  });

  /// Returns `true` when a valid session exists (kept or refreshed).
  Future<Result<bool>> checkSession();

  Future<Result<MemberEntity>> getProfile();

  Future<Result<bool>> updatePushNotifications({required bool enabled});

  Future<Result<void>> logout();
}
