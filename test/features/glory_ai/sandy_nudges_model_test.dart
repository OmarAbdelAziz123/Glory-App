import 'package:flutter_test/flutter_test.dart';
import 'package:glory_gym/features/glory_ai/data/models/sandy_nudges_model.dart';

void main() {
  group('readSandyNudgesEnabled', () {
    test('reads enabled from data wrapper', () {
      expect(
        readSandyNudgesEnabled({
          'success': true,
          'data': {'enabled': false},
        }),
        isFalse,
      );
    });

    test('defaults to true when missing', () {
      expect(readSandyNudgesEnabled({'success': true}), isTrue);
    });
  });
}
