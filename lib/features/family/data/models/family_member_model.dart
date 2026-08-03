import 'package:json_annotation/json_annotation.dart';

part 'family_member_model.g.dart';

@JsonSerializable()
final class FamilyMemberModel {
  const FamilyMemberModel({
    required this.id,
    required this.memberId,
    required this.fullName,
    this.email,
    this.phone,
    this.gender,
    this.dateOfBirth,
    required this.relation,
    required this.createdAt,
  });

  factory FamilyMemberModel.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberModelFromJson(json);

  final String id;
  final String memberId;
  final String fullName;
  final String? email;
  final String? phone;
  final String? gender;
  final String? dateOfBirth;
  final String relation;
  final String createdAt;
}
