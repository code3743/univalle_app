import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/auth/auth_strings.dart';
import 'package:univalle_app/features/auth/presentation/utils/username_validator.dart';

void main() {
  test('requires a value', () {
    expect(validateUsername(null), AuthStrings.usernameRequired);
    expect(validateUsername('  '), AuthStrings.usernameRequired);
  });

  test('accepts code-program with 4+ and 2+ digits', () {
    expect(validateUsername('2012345-3744'), isNull);
    expect(validateUsername(' 1234-12 '), isNull);
  });

  test('rejects malformed usernames', () {
    for (final value in [
      'jdoe',
      '123-45',
      '1234-5',
      '1234',
      '1234-ab',
      '1234--12',
    ]) {
      expect(
        validateUsername(value),
        AuthStrings.usernameInvalid,
        reason: value,
      );
    }
  });
}
