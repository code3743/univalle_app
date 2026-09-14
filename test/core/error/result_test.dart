import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';

void main() {
  group('Ok', () {
    test('isOk is true and isErr is false', () {
      const result = Ok<int>(42);
      expect(result.isOk, isTrue);
      expect(result.isErr, isFalse);
    });

    test('fold calls onSuccess with the value', () {
      const result = Ok<int>(42);
      final folded = result.fold(
        onError: (_) => 'error',
        onSuccess: (value) => 'ok:$value',
      );
      expect(folded, 'ok:42');
    });
  });

  group('Err', () {
    test('isErr is true and isOk is false', () {
      final result = Err<int>(UnknownFailure(message: 'x'));
      expect(result.isErr, isTrue);
      expect(result.isOk, isFalse);
    });

    test('fold calls onError with the failure', () {
      final failure = UnknownFailure(message: 'x');
      final result = Err<int>(failure);
      final folded = result.fold(
        onError: (f) => 'error:${f.message}',
        onSuccess: (_) => 'ok',
      );
      expect(folded, 'error:x');
    });
  });
}
