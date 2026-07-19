import '../../../../core/result/result.dart';
import '../entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<Result<UserEntity>> login({
    required String phone,
    required String password,
  });

  Future<Result<void>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  });

  Future<Result<void>> sendOtp({required String phone});

  Future<Result<void>> verifyOtp({
    required String phone,
    required String otp,
  });

  Future<Result<void>> resetPassword({
    required String phone,
    required String newPassword,
  });

  Future<Result<void>> logout();
}
