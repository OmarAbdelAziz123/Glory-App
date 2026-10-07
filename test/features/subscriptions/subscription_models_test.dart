import 'package:flutter_test/flutter_test.dart';
import 'package:glory_gym/features/subscriptions/data/mappers/subscription_mappers.dart';
import 'package:glory_gym/features/subscriptions/data/models/subscription_model.dart';

void main() {
  test('parses subscription when package nameAr is null', () {
    final entity = SubscriptionModel.fromJson({
      'id': 'cmux1j6z30b051i580jry8p6x',
      'startDate': '2026-10-06T00:00:00.000Z',
      'endDate': '2026-11-05T00:00:00.000Z',
      'status': 'ACTIVE',
      'price': 100.000,
      'sessionCount': 10,
      'remainingSessions': 10,
      'remainingDays': 30,
      'package': {
        'id': 'cmurxsoib00261i7g67dmqnze',
        'nameEn': '10 Session PT * 2 /50 MIN',
        'nameAr': null,
        'membershipType': 'PT',
        'durationUnit': 'DAY',
        'durationValue': 30,
      },
    }).toEntity();

    expect(entity.package.nameAr, '10 Session PT * 2 /50 MIN');
    expect(entity.price, 100);
    expect(entity.packageName(isArabic: true), contains('10 Session'));
  });
}
