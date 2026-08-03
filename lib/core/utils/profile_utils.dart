import 'package:intl/intl.dart';

abstract final class ProfileUtils {
  static const maritalStatuses = <String>[
    'SINGLE',
    'MARRIED',
    'DIVORCED',
    'WIDOWED',
  ];

  static String maritalStatusLabel(String? status) => switch (status) {
        'SINGLE' => 'أعزب',
        'MARRIED' => 'متزوج',
        'DIVORCED' => 'مطلق',
        'WIDOWED' => 'أرمل',
        _ => 'أعزب',
      };

  static String? maritalStatusValue(String label) => switch (label) {
        'أعزب' => 'SINGLE',
        'متزوج' => 'MARRIED',
        'مطلق' => 'DIVORCED',
        'أرمل' => 'WIDOWED',
        _ => null,
      };

  static String formatBirthDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('d MMMM y', 'ar').format(date);
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
