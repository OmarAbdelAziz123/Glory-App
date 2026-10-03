abstract final class SessionCheckinTokenParser {
  static String extract(String rawValue) {
    final trimmed = rawValue.trim();
    if (trimmed.isEmpty) return '';

    final uri = Uri.tryParse(trimmed);
    if (uri == null) return trimmed;

    final queryToken = uri.queryParameters['token'] ??
        uri.queryParameters['code'] ??
        uri.queryParameters['qr'];
    if (queryToken != null && queryToken.isNotEmpty) {
      return queryToken;
    }

    if (uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.last;
    }

    return trimmed;
  }
}
