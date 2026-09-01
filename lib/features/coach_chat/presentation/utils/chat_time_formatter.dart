abstract final class ChatTimeFormatter {
  static String formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String formatConversationTimestamp(
    DateTime? dateTime, {
    String yesterdayLabel = 'Yesterday',
  }) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final local = dateTime.toLocal();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(local.year, local.month, local.day);

    if (messageDay == today) {
      return formatTime(local);
    }

    final yesterday = today.subtract(const Duration(days: 1));
    if (messageDay == yesterday) {
      return yesterdayLabel;
    }

    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    return '$day/$month/${local.year}';
  }
}
