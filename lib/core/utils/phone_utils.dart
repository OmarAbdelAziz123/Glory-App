final class ParsedPhone {
  const ParsedPhone({
    required this.dialCode,
    required this.localNumber,
  });

  final String dialCode;
  final String localNumber;
}

abstract final class PhoneUtils {
  static const _knownDialCodes = [
    '+966',
    '+971',
    '+965',
    '+974',
    '+973',
    '+968',
    '+962',
    '+964',
    '+963',
    '+961',
    '+970',
    '+967',
    '+218',
    '+216',
    '+213',
    '+212',
    '+249',
    '+252',
    '+222',
    '+253',
    '+269',
    '+20',
  ];

  /// Splits a full international phone into [ParsedPhone.dialCode] and
  /// [ParsedPhone.localNumber] (digits only, no country prefix).
  static ParsedPhone splitPhone({
    required String phone,
    String? phoneCountryCode,
  }) {
    final raw = phone.trim();
    if (raw.isEmpty) {
      return ParsedPhone(
        dialCode: _normalizeDialCode(phoneCountryCode) ?? '+966',
        localNumber: '',
      );
    }

    final dialCodes = [..._knownDialCodes]
      ..sort((a, b) => b.length.compareTo(a.length));

    var candidate = raw.startsWith('+') ? raw : '+${raw.replaceAll(RegExp(r'\D'), '')}';

    for (final code in dialCodes) {
      if (candidate.startsWith(code)) {
        final local = candidate
            .substring(code.length)
            .replaceAll(RegExp(r'\D'), '');
        return ParsedPhone(dialCode: code, localNumber: local);
      }
    }

    final digitsOnly = raw.replaceAll(RegExp(r'\D'), '');
    final dialCode = _normalizeDialCode(phoneCountryCode) ?? '+966';
    final dialDigits = dialCode.replaceAll('+', '');

    if (digitsOnly.startsWith(dialDigits) &&
        digitsOnly.length > dialDigits.length) {
      return ParsedPhone(
        dialCode: dialCode,
        localNumber: digitsOnly.substring(dialDigits.length),
      );
    }

    return ParsedPhone(dialCode: dialCode, localNumber: digitsOnly);
  }

  static String? _normalizeDialCode(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final trimmed = value.trim();
    return trimmed.startsWith('+') ? trimmed : '+$trimmed';
  }
}
