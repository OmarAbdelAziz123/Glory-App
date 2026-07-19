import '../../../../core/result/result.dart';
import '../entities/family_member_entity.dart';

abstract interface class FamilyRepository {
  Future<Result<List<FamilyMemberEntity>>> getFamilyMembers();

  Future<Result<void>> addFamilyMember({
    required String name,
    required String phone,
    required String relation,
  });

  Future<Result<void>> removeFamilyMember(String id);
}
