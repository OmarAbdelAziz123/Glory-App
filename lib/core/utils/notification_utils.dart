import 'package:glory_gym/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../features/notifications/domain/entities/notification_entity.dart';

abstract final class NotificationUtils {
  static String title(NotificationEntity notification, {String locale = 'ar'}) {
    return locale == 'ar' ? notification.titleAr : notification.titleEn;
  }

  static String body(NotificationEntity notification, {String locale = 'ar'}) {
    return locale == 'ar' ? notification.bodyAr : notification.bodyEn;
  }

  static String subtitle(NotificationEntity notification, {String locale = 'ar'}) {
    final text = body(notification, locale: locale);
    if (text.length <= 60) return text;
    return '${text.substring(0, 60)}...';
  }

  static String groupLabel(AppLocalizations l10n, DateTime createdAt) {
    final now = DateTime.now();
    final local = createdAt.toLocal();
    final today = DateTime(now.year, now.month, now.day);
    final createdDay = DateTime(local.year, local.month, local.day);

    if (createdDay == today) return l10n.today;

    final yesterday = today.subtract(const Duration(days: 1));
    if (createdDay == yesterday) return l10n.yesterday;

    return DateFormat('d MMMM y', l10n.localeName).format(local);
  }

  static List<NotificationGroupEntity> groupByDate(
    AppLocalizations l10n,
    List<NotificationEntity> notifications,
  ) {
    final grouped = <String, List<NotificationEntity>>{};
    for (final notification in notifications) {
      final label = groupLabel(l10n, notification.createdAt);
      grouped.putIfAbsent(label, () => []).add(notification);
    }

    return grouped.entries
        .map(
          (entry) => NotificationGroupEntity(
            label: entry.key,
            items: entry.value,
          ),
        )
        .toList();
  }

  static String localeFromAppLanguage(String? appLanguage) =>
      appLanguage == 'en' ? 'en' : 'ar';
}

final class NotificationGroupEntity {
  const NotificationGroupEntity({
    required this.label,
    required this.items,
  });

  final String label;
  final List<NotificationEntity> items;
}
