import '../../../../core/result/result.dart';
import '../entities/settings_entity.dart';

abstract interface class SettingsRepository {
  Future<Result<SettingsEntity>> getSettings();

  Future<Result<void>> updateLanguage(String languageCode);

  Future<Result<void>> updateNotificationsEnabled(bool enabled);

  Future<Result<void>> updateBiometricEnabled(bool enabled);
}
