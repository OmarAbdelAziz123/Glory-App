final class UserEntity {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;
}
