// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FamilyMemberModel _$FamilyMemberModelFromJson(Map<String, dynamic> json) =>
    FamilyMemberModel(
      id: json['id'] as String,
      memberId: json['memberId'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      relation: json['relation'] as String,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$FamilyMemberModelToJson(FamilyMemberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memberId': instance.memberId,
      'fullName': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth,
      'relation': instance.relation,
      'createdAt': instance.createdAt,
    };
