import 'package:flutter_test/flutter_test.dart';
import 'package:glory_gym/features/about/data/models/contact_links_parser.dart';

void main() {
  test('parses mobile contact channels list', () {
    final channels = readContactChannelsData([
      {
        'id': '1',
        'icon': 'WHATSAPP',
        'labelEn': 'Whatsapp',
        'labelAr': 'واتساب',
        'value': 'https://wa.me/201000000000',
      },
      {
        'id': '2',
        'icon': 'INSTAGRAM',
        'labelEn': 'Instagram',
        'labelAr': 'انستجرام',
        'value': 'https://instagram.com/glorygym',
      },
    ]);

    expect(channels, hasLength(2));
    expect(channels!.first.icon, 'WHATSAPP');
    expect(channels.last.value, contains('instagram'));
  });

  test('parses legacy flat map', () {
    final channels = readContactChannelsData({
      'social.facebook': 'https://facebook.com/glory',
      'contact.phone': '+962790000000',
    });

    expect(channels, hasLength(2));
    expect(channels!.any((c) => c.icon == 'FACEBOOK'), isTrue);
    expect(channels.any((c) => c.icon == 'PHONE'), isTrue);
  });
}
