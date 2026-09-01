import 'package:glory_gym/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

abstract final class FamilyUtils {
  static const genders = <String>['MALE', 'FEMALE'];

  static const relations = <String>[
    'SON',
    'DAUGHTER',
    'FATHER',
    'MOTHER',
    'BROTHER',
    'SISTER',
    'HUSBAND',
    'WIFE',
  ];

  static List<String> genderLabels(AppLocalizations l10n) => [
        l10n.genderMale,
        l10n.genderFemale,
      ];

  static List<String> relationLabels(AppLocalizations l10n) => [
        l10n.relationSon,
        l10n.relationDaughter,
        l10n.relationFather,
        l10n.relationMother,
        l10n.relationBrother,
        l10n.relationSister,
        l10n.relationHusband,
        l10n.relationWife,
      ];

  static String genderLabel(AppLocalizations l10n, String? gender) =>
      switch (gender) {
        'MALE' => l10n.genderMale,
        'FEMALE' => l10n.genderFemale,
        _ => '',
      };

  static String? genderValue(AppLocalizations l10n, String label) {
    for (final gender in genders) {
      if (genderLabel(l10n, gender) == label) return gender;
    }
    return null;
  }

  static String relationLabel(AppLocalizations l10n, String? relation) =>
      switch (relation) {
        'SON' => l10n.relationSon,
        'DAUGHTER' => l10n.relationDaughter,
        'FATHER' => l10n.relationFather,
        'MOTHER' => l10n.relationMother,
        'BROTHER' => l10n.relationBrother,
        'SISTER' => l10n.relationSister,
        'HUSBAND' => l10n.relationHusband,
        'WIFE' => l10n.relationWife,
        _ => '',
      };

  static String? relationValue(AppLocalizations l10n, String label) {
    for (final relation in relations) {
      if (relationLabel(l10n, relation) == label) return relation;
    }
    return null;
  }

  static String formatBirthDate(AppLocalizations l10n, DateTime? date) {
    if (date == null) return '';
    return DateFormat('d MMMM y', l10n.localeName).format(date);
  }

  static String formatAddedDate(AppLocalizations l10n, DateTime? date) {
    if (date == null) return '';
    return DateFormat('d MMMM y', l10n.localeName).format(date);
  }

  static String? toApiDate(DateTime? date) {
    if (date == null) return null;
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static DateTime? parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}
