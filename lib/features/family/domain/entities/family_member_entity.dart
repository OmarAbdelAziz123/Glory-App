final class FamilyMemberEntity {
  const FamilyMemberEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.relation,
    this.avatarUrl,
    this.subscriptionStatus,
  });

  final String id;
  final String name;
  final String phone;
  final String relation;
  final String? avatarUrl;
  final String? subscriptionStatus;
}
