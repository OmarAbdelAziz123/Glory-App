final class CountryCode {
  const CountryCode({
    required this.name,
    required this.dialCode,
    required this.countryCode,
  });

  final String name;
  final String dialCode;

  /// ISO 3166-1 alpha-2 (e.g. `SA`, `EG`) for [CountryFlag.fromCountryCode].
  final String countryCode;
}
