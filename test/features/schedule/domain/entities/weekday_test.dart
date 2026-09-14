import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/schedule/domain/entities/weekday.dart';

void main() {
  group('Weekday.fromSiraCode', () {
    const cases = {
      'LUN': Weekday.monday,
      'MAR': Weekday.tuesday,
      'MIE': Weekday.wednesday,
      'MIÉ': Weekday.wednesday,
      'JUE': Weekday.thursday,
      'VIE': Weekday.friday,
      'SAB': Weekday.saturday,
      'DOM': Weekday.sunday,
    };

    cases.forEach((code, expected) {
      test('parses "$code" as $expected', () {
        expect(Weekday.fromSiraCode(code), expected);
      });
    });

    test('is case-insensitive and trims whitespace', () {
      expect(Weekday.fromSiraCode(' lun '), Weekday.monday);
    });

    test('returns null for an unrecognized code', () {
      expect(Weekday.fromSiraCode('XXX'), isNull);
    });
  });
}
