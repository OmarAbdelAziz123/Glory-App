import 'package:glory_gym/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

abstract final class ProfileUtils {
  static const maritalStatuses = <String>[
    'SINGLE',
    'MARRIED',
    'DIVORCED',
    'WIDOWED',
  ];

  static String maritalStatusLabel(AppLocalizations l10n, String? status) =>
      switch (status) {
        'SINGLE' => l10n.maritalSingle,
        'MARRIED' => l10n.maritalMarried,
        'DIVORCED' => l10n.maritalDivorced,
        'WIDOWED' => l10n.maritalWidowed,
        _ => l10n.maritalSingle,
      };

  static String? maritalStatusValue(AppLocalizations l10n, String label) {
    for (final status in maritalStatuses) {
      if (maritalStatusLabel(l10n, status) == label) return status;
    }
    return null;
  }

  static String formatBirthDate(AppLocalizations l10n, DateTime? date) {
    if (date == null) return '';
    return DateFormat('d MMMM y', l10n.localeName).format(date);
  }

  static String? toApiDate(DateTime? date) {
    if (date == null) return null;
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static DateTime? parseBirthDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}
