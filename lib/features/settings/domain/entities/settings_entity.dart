final class SettingsEntity {
  const SettingsEntity({
    required this.language,
    required this.notificationsEnabled,
    required this.biometricEnabled,
  });

  final String language;
  final bool notificationsEnabled;
  final bool biometricEnabled;
}
