import 'package:glory_gym/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../features/subscriptions/domain/entities/subscription_entity.dart';

abstract final class SubscriptionUtils {
  static String formatDate(AppLocalizations l10n, DateTime dateTime) {
    return DateFormat('d MMMM y', l10n.localeName).format(dateTime.toLocal());
  }

  static String packageTypeLabel(
    AppLocalizations l10n,
    SubscriptionEntity subscription,
  ) {
    final package = subscription.package;
    return switch (package.membershipType.toUpperCase()) {
      'PT' => l10n.sessions,
      'GYM' => l10n.gym,
      _ => switch (package.durationUnit.toUpperCase()) {
          'SESSION' => l10n.sessions,
          'MONTH' => l10n.gym,
          _ => package.membershipType,
        },
    };
  }
}
