import '../../../../core/result/result.dart';
import '../entities/profile_entity.dart';

abstract interface class ProfileRepository {
  Future<Result<ProfileEntity>> getProfile();

  Future<Result<ProfileEntity>> updateProfile({
    String? name,
    String? email,
    String? phone,
    DateTime? birthDate,
    String? gender,
    double? height,
    double? weight,
    String? avatarPath,
  });
}
