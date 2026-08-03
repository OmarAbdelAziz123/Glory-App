import '../../../../core/error/app_failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/family_utils.dart';
import '../../domain/entities/family_member_entity.dart';
import '../../domain/repositories/family_repository.dart';
import '../datasources/family_remote_api_service.dart';
import '../mappers/family_mappers.dart';
import '../models/family_api_responses.dart';
import '../models/add_family_member_request.dart';
import '../models/update_family_member_request.dart';

final class FamilyRepositoryImpl implements FamilyRepository {
  const FamilyRepositoryImpl(this._remote);

  final FamilyRemoteApiService _remote;

  @override
  Future<Result<FamilyMembersPageEntity>> getFamilyMembers({
    int page = 1,
    int limit = 10,
  }) async {
    final result = await _remote.getFamilyMembers(page: page, limit: limit);

    return switch (result) {
      Success(:final data) => _mapPage(data),
      Failure(:final failure) => Failure(failure),
    };
  }

  Result<FamilyMembersPageEntity> _mapPage(FamilyMembersApiResponse data) {
    final pageEntity = data.toPageEntity();
    if (pageEntity == null) {
      return const Failure(ServerFailure('حدث خطأ، حاول مرة أخرى'));
    }
    return Success(pageEntity);
  }

  @override
  Future<Result<FamilyMemberEntity>> addFamilyMember({
    required String fullName,
    required DateTime dateOfBirth,
    required String gender,
    required String relation,
  }) async {
    final result = await _remote.addFamilyMember(
      AddFamilyMemberRequest(
        fullName: fullName,
        dateOfBirth: FamilyUtils.toApiDate(dateOfBirth)!,
        gender: gender,
        relation: relation,
      ),
    );

    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<FamilyMemberEntity>> updateFamilyMember({
    required String id,
    required String fullName,
    required DateTime dateOfBirth,
    required String gender,
    required String relation,
  }) async {
    final result = await _remote.updateFamilyMember(
      id: id,
      request: UpdateFamilyMemberRequest(
        fullName: fullName,
        dateOfBirth: FamilyUtils.toApiDate(dateOfBirth),
        gender: gender,
        relation: relation,
      ),
    );

    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<void>> deleteFamilyMember(String id) async {
    final result = await _remote.deleteFamilyMember(id);

    return switch (result) {
      Success() => const Success(null),
      Failure(:final failure) => Failure(failure),
    };
  }
}
