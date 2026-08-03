import '../../domain/entities/member_entity.dart';
import '../../../../core/utils/profile_utils.dart';
import '../models/member_model.dart';
import '../models/login_model.dart';
import '../models/otp_sent_model.dart';
import '../models/verify_otp_model.dart';
import '../../domain/entities/otp_sent_entity.dart';
import '../../domain/entities/auth_session_entity.dart';

extension MemberModelMapper on MemberModel {
  MemberEntity toEntity() => MemberEntity(
        id: id,
        memberCode: memberCode,
        fullName: fullName,
        email: email,
        phone: phone,
        phoneCountryCode: phoneCountryCode,
        avatarUrl: avatarUrl,
        gender: gender,
        dateOfBirth: ProfileUtils.parseBirthDate(dateOfBirth),
        maritalStatus: maritalStatus,
        healthNotes: healthNotes,
        pushEnabled: pushEnabled,
        appLanguage: appLanguage,
        status: status,
        source: source,
        emailVerifiedAt: emailVerifiedAt != null
            ? DateTime.tryParse(emailVerifiedAt!)
            : null,
        createdAt: DateTime.parse(createdAt),
      );
}

extension OtpSentModelMapper on OtpSentModel {
  OtpSentEntity toEntity() => OtpSentEntity(
        email: email,
        purpose: purpose,
        expiresInSeconds: expiresInSeconds,
        resendCooldownSeconds: resendCooldownSeconds,
      );
}

extension VerifyOtpModelMapper on VerifyOtpModel {
  VerifyOtpEntity toEntity() => VerifyOtpEntity(
        otpToken: otpToken,
        purpose: purpose,
      );
}

extension LoginModelMapper on LoginModel {
  AuthSessionEntity toEntity() => AuthSessionEntity(
        accessToken: accessToken,
        refreshToken: refreshToken,
        member: member.toEntity(),
      );
}
