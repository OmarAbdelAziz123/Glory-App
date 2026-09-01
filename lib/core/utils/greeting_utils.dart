import 'package:glory_gym/l10n/app_localizations.dart';

abstract final class GreetingUtils {
  static String greeting(AppLocalizations l10n, [DateTime? now]) {
    final hour = (now ?? DateTime.now()).hour;
    if (hour < 12) return l10n.goodMorning;
    return l10n.goodEvening;
  }
}
