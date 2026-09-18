final class MemberEntity {
  const MemberEntity({
    required this.id,
    required this.memberCode,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.phoneCountryCode,
    this.avatarUrl,
    this.gender,
    this.dateOfBirth,
    this.maritalStatus,
    this.healthNotes,
    this.pushEnabled = true,
    this.appLanguage = 'ar',
    required this.status,
    required this.source,
    this.emailVerifiedAt,
    this.onboardingCompleted,
    required this.createdAt,
  });

  final String id;
  final String memberCode;
  final String fullName;
  final String email;
  final String phone;
  final String phoneCountryCode;
  final String? avatarUrl;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? maritalStatus;
  final String? healthNotes;
  final bool pushEnabled;
  final String appLanguage;
  final String status;
  final String source;
  final DateTime? emailVerifiedAt;
  final bool? onboardingCompleted;
  final DateTime createdAt;

  MemberEntity copyWith({
    String? id,
    String? memberCode,
    String? fullName,
    String? email,
    String? phone,
    String? phoneCountryCode,
    String? avatarUrl,
    String? gender,
    DateTime? dateOfBirth,
    String? maritalStatus,
    String? healthNotes,
    bool? pushEnabled,
    String? appLanguage,
    String? status,
    String? source,
    DateTime? emailVerifiedAt,
    bool? onboardingCompleted,
    DateTime? createdAt,
  }) =>
      MemberEntity(
        id: id ?? this.id,
        memberCode: memberCode ?? this.memberCode,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        phoneCountryCode: phoneCountryCode ?? this.phoneCountryCode,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        gender: gender ?? this.gender,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        maritalStatus: maritalStatus ?? this.maritalStatus,
        healthNotes: healthNotes ?? this.healthNotes,
        pushEnabled: pushEnabled ?? this.pushEnabled,
        appLanguage: appLanguage ?? this.appLanguage,
        status: status ?? this.status,
        source: source ?? this.source,
        emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
        onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
        createdAt: createdAt ?? this.createdAt,
      );
}
