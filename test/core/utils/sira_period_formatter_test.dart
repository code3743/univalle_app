import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/utils/sira_period_formatter.dart';

void main() {
  group('SiraPeriodFormatter.format', () {
    test('shortens a well-formed period', () {
      expect(
        SiraPeriodFormatter.format('FEBRERO/2022 - JUNIO/2022'),
        'Feb/22 – Jun/22',
      );
    });

    test('trims whitespace around each side', () {
      expect(
        SiraPeriodFormatter.format(' AGOSTO/2023 -DICIEMBRE/2023 '),
        'Ago/23 – Dic/23',
      );
    });

    test('returns the raw input when it has no dash-separated range', () {
      expect(SiraPeriodFormatter.format('FEBRERO/2022'), 'FEBRERO/2022');
    });

    test('returns the raw input when a month is not recognized', () {
      const raw = 'FOO/2022 - JUNIO/2022';
      expect(SiraPeriodFormatter.format(raw), raw);
    });

    test('returns the raw input when a side has no year', () {
      const raw = 'FEBRERO - JUNIO/2022';
      expect(SiraPeriodFormatter.format(raw), raw);
    });
  });

  group('SiraPeriodFormatter.shortCode', () {
    test('derives semester 1 for a period starting Feb-Jun', () {
      expect(
        SiraPeriodFormatter.shortCode('FEBRERO/2022 - JUNIO/2022'),
        '2022-1',
      );
      expect(
        SiraPeriodFormatter.shortCode('JUNIO/2022 - JUNIO/2022'),
        '2022-1',
      );
    });

    test('derives semester 2 for a period starting Jul-Dec', () {
      expect(
        SiraPeriodFormatter.shortCode('AGOSTO/2023 - DICIEMBRE/2023'),
        '2023-2',
      );
      expect(
        SiraPeriodFormatter.shortCode('JULIO/2023 - DICIEMBRE/2023'),
        '2023-2',
      );
    });

    test('returns the raw input when the start month is not recognized', () {
      const raw = 'FOO/2022 - JUNIO/2022';
      expect(SiraPeriodFormatter.shortCode(raw), raw);
    });

    test('returns the raw input when the year is malformed', () {
      const raw = 'FEBRERO/22 - JUNIO/2022';
      expect(SiraPeriodFormatter.shortCode(raw), raw);
    });

    test('returns the raw input when there is no month/year split', () {
      const raw = 'FEBRERO - JUNIO/2022';
      expect(SiraPeriodFormatter.shortCode(raw), raw);
    });
  });
}
