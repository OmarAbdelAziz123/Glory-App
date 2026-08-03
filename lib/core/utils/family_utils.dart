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

  static const relationLabels = <String>[
    'ابن',
    'ابنة',
    'أب',
    'أم',
    'أخ',
    'أخت',
    'زوج',
    'زوجة',
  ];

  static const genderLabels = <String>['ذكر', 'أنثى'];

  static String genderLabel(String? gender) => switch (gender) {
        'MALE' => 'ذكر',
        'FEMALE' => 'أنثى',
        _ => '',
      };

  static String? genderValue(String label) => switch (label) {
        'ذكر' => 'MALE',
        'أنثى' => 'FEMALE',
        _ => null,
      };

  static String relationLabel(String? relation) => switch (relation) {
        'SON' => 'ابن',
        'DAUGHTER' => 'ابنة',
        'FATHER' => 'أب',
        'MOTHER' => 'أم',
        'BROTHER' => 'أخ',
        'SISTER' => 'أخت',
        'HUSBAND' => 'زوج',
        'WIFE' => 'زوجة',
        _ => '',
      };

  static String? relationValue(String label) => switch (label) {
        'ابن' => 'SON',
        'ابنة' => 'DAUGHTER',
        'أب' => 'FATHER',
        'أم' => 'MOTHER',
        'أخ' => 'BROTHER',
        'أخت' => 'SISTER',
        'زوج' => 'HUSBAND',
        'زوجة' => 'WIFE',
        _ => null,
      };

  static String formatBirthDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('d MMMM y', 'ar').format(date);
  }

  static String formatAddedDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('d MMMM y', 'ar').format(date);
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
