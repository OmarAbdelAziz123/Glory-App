import '../../../../core/result/result.dart';
import '../entities/family_member_entity.dart';

abstract interface class FamilyRepository {
  Future<Result<FamilyMembersPageEntity>> getFamilyMembers({
    int page = 1,
    int limit = 10,
  });

  Future<Result<FamilyMemberEntity>> addFamilyMember({
    required String fullName,
    required DateTime dateOfBirth,
    required String gender,
    required String relation,
  });

  Future<Result<FamilyMemberEntity>> updateFamilyMember({
    required String id,
    required String fullName,
    required DateTime dateOfBirth,
    required String gender,
    required String relation,
  });

  Future<Result<void>> deleteFamilyMember(String id);
}
