import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:univalle_app/core/utils/date_formatter.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('es');
  });

  group('AppDateFormatter.short', () {
    test('formats as dd/MM/yyyy', () {
      expect(AppDateFormatter.short(DateTime(2026, 3, 5)), '05/03/2026');
    });
  });

  group('AppDateFormatter.long', () {
    test('formats as "d de MMMM de y" in Spanish', () {
      expect(AppDateFormatter.long(DateTime(2026, 3, 5)), '5 de marzo de 2026');
    });
  });

  group('AppDateFormatter.tryParse', () {
    test('parses a valid dd/MM/yyyy string', () {
      expect(AppDateFormatter.tryParse('05/03/2026'), DateTime(2026, 3, 5));
    });

    test('returns null for an invalid string', () {
      expect(AppDateFormatter.tryParse('not-a-date'), isNull);
    });

    test('returns null when the string does not match the given pattern', () {
      expect(AppDateFormatter.tryParse('2026-03-05'), isNull);
    });
  });
}
