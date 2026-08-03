import 'dart:convert';

abstract final class JwtUtils {
  static bool isExpired(
    String token, {
    Duration leeway = const Duration(seconds: 30),
  }) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final map = jsonDecode(decoded) as Map<String, dynamic>;
      final exp = map['exp'];

      if (exp is! num) return true;

      final expiry = DateTime.fromMillisecondsSinceEpoch(exp.toInt() * 1000);
      return DateTime.now().isAfter(expiry.subtract(leeway));
    } catch (_) {
      return true;
    }
  }
}
