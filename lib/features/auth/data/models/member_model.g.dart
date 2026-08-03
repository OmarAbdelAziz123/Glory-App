// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberModel _$MemberModelFromJson(Map<String, dynamic> json) => MemberModel(
  id: json['id'] as String,
  memberCode: json['memberCode'] as String,
  fullName: json['fullName'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  phoneCountryCode: json['phoneCountryCode'] as String,
  avatarUrl: json['avatarUrl'] as String?,
  gender: json['gender'] as String?,
  dateOfBirth: json['dateOfBirth'] as String?,
  maritalStatus: json['maritalStatus'] as String?,
  healthNotes: json['healthNotes'] as String?,
  pushEnabled: json['pushEnabled'] as bool? ?? true,
  appLanguage: json['appLanguage'] as String? ?? 'ar',
  status: json['status'] as String,
  source: json['source'] as String,
  emailVerifiedAt: json['emailVerifiedAt'] as String?,
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$MemberModelToJson(MemberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memberCode': instance.memberCode,
      'fullName': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'phoneCountryCode': instance.phoneCountryCode,
      'avatarUrl': instance.avatarUrl,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth,
      'maritalStatus': instance.maritalStatus,
      'healthNotes': instance.healthNotes,
      'pushEnabled': instance.pushEnabled,
      'appLanguage': instance.appLanguage,
      'status': instance.status,
      'source': instance.source,
      'emailVerifiedAt': instance.emailVerifiedAt,
      'createdAt': instance.createdAt,
    };
