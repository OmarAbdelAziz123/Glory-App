import 'package:json_annotation/json_annotation.dart';

part 'member_model.g.dart';

@JsonSerializable()
final class MemberModel {
  const MemberModel({
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
    required this.createdAt,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);

  final String id;
  final String memberCode;
  final String fullName;
  final String email;
  final String phone;
  final String phoneCountryCode;
  final String? avatarUrl;
  final String? gender;
  final String? dateOfBirth;
  final String? maritalStatus;
  final String? healthNotes;
  @JsonKey(defaultValue: true)
  final bool pushEnabled;
  @JsonKey(defaultValue: 'ar')
  final String appLanguage;
  final String status;
  final String source;
  final String? emailVerifiedAt;
  final String createdAt;
}
