import '../../../../core/utils/family_utils.dart';
import '../../domain/entities/family_member_entity.dart';
import '../models/family_member_model.dart';
import '../models/family_api_responses.dart';

extension FamilyMemberModelMapper on FamilyMemberModel {
  FamilyMemberEntity toEntity() => FamilyMemberEntity(
        id: id,
        memberId: memberId,
        fullName: fullName,
        email: email,
        phone: phone,
        gender: gender,
        dateOfBirth: FamilyUtils.parseDate(dateOfBirth),
        relation: relation,
        createdAt: DateTime.parse(createdAt),
      );
}

extension FamilyMembersPageMapper on FamilyMembersApiResponse {
  FamilyMembersPageEntity? toPageEntity() {
    final members = data;
    final pagination = meta;
    if (members == null || pagination == null) return null;

    return FamilyMembersPageEntity(
      items: members.map((member) => member.toEntity()).toList(),
      page: pagination.page,
      limit: pagination.limit,
      total: pagination.total,
      totalPages: pagination.totalPages,
    );
  }
}
