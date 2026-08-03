import 'package:json_annotation/json_annotation.dart';

part 'add_family_member_request.g.dart';

@JsonSerializable(createFactory: false)
final class AddFamilyMemberRequest {
  const AddFamilyMemberRequest({
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.relation,
  });

  Map<String, dynamic> toJson() => _$AddFamilyMemberRequestToJson(this);

  final String fullName;
  final String dateOfBirth;
  final String gender;
  final String relation;
}
