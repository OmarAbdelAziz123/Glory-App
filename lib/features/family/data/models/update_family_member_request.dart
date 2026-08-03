import 'package:json_annotation/json_annotation.dart';

part 'update_family_member_request.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
final class UpdateFamilyMemberRequest {
  const UpdateFamilyMemberRequest({
    this.fullName,
    this.dateOfBirth,
    this.gender,
    this.relation,
  });

  Map<String, dynamic> toJson() => _$UpdateFamilyMemberRequestToJson(this);

  final String? fullName;
  final String? dateOfBirth;
  final String? gender;
  final String? relation;
}
