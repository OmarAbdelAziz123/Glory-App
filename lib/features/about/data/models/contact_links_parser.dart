import 'contact_channel_model.dart';
import 'contact_links_model.dart';

List<ContactChannelModel>? readContactChannelsData(dynamic data) {
  if (data == null) return null;

  if (data is List) {
    final channels = <ContactChannelModel>[];
    for (final item in data) {
      if (item is! Map) continue;
      final map = item.map((key, value) => MapEntry(key.toString(), value));
      if (_isContactChannelRow(map)) {
        channels.add(ContactChannelModel.fromJson(map));
        continue;
      }
      final legacy = _legacyRowToChannel(map);
      if (legacy != null) channels.add(legacy);
    }
    return channels;
  }

  if (data is Map) {
    final map = data.map((key, value) => MapEntry(key.toString(), value));
    if (_isContactChannelRow(map)) {
      return [ContactChannelModel.fromJson(map)];
    }
    return _legacyFlatMapToChannels(map);
  }

  return null;
}

bool _isContactChannelRow(Map<String, dynamic> map) =>
    map.containsKey('icon') &&
    map.containsKey('value') &&
    map.containsKey('labelEn') &&
    map.containsKey('labelAr');

ContactChannelModel? _legacyRowToChannel(Map<String, dynamic> map) {
  final key = map['key']?.toString();
  if (key == null || key.isEmpty) return null;

  final value = map['value'] ??
      map['url'] ??
      map['link'] ??
      map['href'] ??
      map['valueEn'] ??
      map['valueAr'];
  if (value == null || value.toString().isEmpty) return null;

  final icon = _iconFromLegacyKey(key);
  return ContactChannelModel(
    id: map['id']?.toString() ?? key,
    icon: icon,
    labelEn: map['labelEn']?.toString() ?? key,
    labelAr: map['labelAr']?.toString() ?? key,
    value: value.toString(),
  );
}

List<ContactChannelModel> _legacyFlatMapToChannels(Map<String, dynamic> map) {
  final links = ContactLinksModel.fromJson(map);
  final channels = <ContactChannelModel>[];

  void add(String icon, String? value, String labelEn, String labelAr) {
    if (value == null || value.isEmpty) return;
    channels.add(
      ContactChannelModel(
        id: icon,
        icon: icon,
        labelEn: labelEn,
        labelAr: labelAr,
        value: value,
      ),
    );
  }

  add('WHATSAPP', links.whatsapp, 'WhatsApp', 'واتساب');
  add('FACEBOOK', links.facebook, 'Facebook', 'فيسبوك');
  add('INSTAGRAM', links.instagram, 'Instagram', 'انستجرام');
  add('X', links.twitter, 'X', 'إكس');
  add('PHONE', links.phone, 'Phone', 'هاتف');
  add('APP_STORE', links.appStore, 'App Store', 'آب ستور');
  add('GOOGLE_PLAY', links.playStore, 'Google Play', 'جوجل بلاي');

  return channels;
}

String _iconFromLegacyKey(String key) {
  final normalized = key.toLowerCase();
  if (normalized.contains('whatsapp')) return 'WHATSAPP';
  if (normalized.contains('facebook')) return 'FACEBOOK';
  if (normalized.contains('instagram')) return 'INSTAGRAM';
  if (normalized.contains('twitter') || normalized.endsWith('.x')) {
    return 'X';
  }
  if (normalized.contains('phone')) return 'PHONE';
  if (normalized.contains('appstore')) return 'APP_STORE';
  if (normalized.contains('playstore')) return 'GOOGLE_PLAY';
  return key.toUpperCase();
}
