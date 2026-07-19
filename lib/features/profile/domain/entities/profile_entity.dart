final class ProfileEntity {
  const ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.birthDate,
    this.avatarUrl,
    this.gender,
    this.height,
    this.weight,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime birthDate;
  final String? avatarUrl;
  final String? gender;
  final double? height;
  final double? weight;
}
