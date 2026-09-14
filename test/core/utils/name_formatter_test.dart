import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/utils/name_formatter.dart';

void main() {
  group('NameFormatter.firstName', () {
    test('capitalizes only the first letter of the first word', () {
      expect(NameFormatter.firstName('JUAN CAMILO PEREZ'), 'Juan');
    });

    test('trims surrounding whitespace', () {
      expect(NameFormatter.firstName('  ana maria  '), 'Ana');
    });

    test('returns an empty string for blank input', () {
      expect(NameFormatter.firstName('   '), '');
    });

    test('handles a single-word name', () {
      expect(NameFormatter.firstName('maria'), 'Maria');
    });

    test('collapses multiple spaces between words', () {
      expect(NameFormatter.firstName('LUIS    FERNANDO'), 'Luis');
    });
  });

  group('NameFormatter.initial', () {
    test('returns the uppercased first character', () {
      expect(NameFormatter.initial('maria'), 'M');
    });

    test('trims surrounding whitespace before taking the first character', () {
      expect(NameFormatter.initial('  paula'), 'P');
    });

    test('returns the fallback for blank input', () {
      expect(NameFormatter.initial('   '), '?');
    });

    test('accepts a custom fallback', () {
      expect(NameFormatter.initial('', fallback: '-'), '-');
    });
  });
}
