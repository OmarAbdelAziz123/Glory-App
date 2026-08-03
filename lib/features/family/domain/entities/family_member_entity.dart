final class FamilyMemberEntity {
  const FamilyMemberEntity({
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

  final String id;
  final String memberId;
  final String fullName;
  final String? email;
  final String? phone;
  final String? gender;
  final DateTime? dateOfBirth;
  final String relation;
  final DateTime createdAt;
}

final class FamilyMembersPageEntity {
  const FamilyMembersPageEntity({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  final List<FamilyMemberEntity> items;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  bool get hasMore => page < totalPages;
}
