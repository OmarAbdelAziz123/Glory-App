bool readSandyNudgesEnabled(dynamic value) {
  if (value is! Map) return true;

  final map = value.map((key, item) => MapEntry(key.toString(), item));
  if (map.containsKey('enabled')) {
    final enabled = map['enabled'];
    if (enabled is bool) return enabled;
    if (enabled is num) return enabled != 0;
    return enabled?.toString().toLowerCase() != 'false';
  }

  final data = map['data'];
  if (data is Map) {
    return readSandyNudgesEnabled(data);
  }

  return true;
}
