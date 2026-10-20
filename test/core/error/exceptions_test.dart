import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/error/exceptions.dart';

void main() {
  test('ServerException carries an optional status code', () {
    const exception = ServerException(message: 'boom', statusCode: 500);
    expect(exception.message, 'boom');
    expect(exception.statusCode, 500);
  });

  test('NetworkException carries its message', () {
    expect(const NetworkException(message: 'boom').message, 'boom');
  });

  test('CacheException carries its message', () {
    expect(const CacheException(message: 'boom').message, 'boom');
  });

  test('AuthException carries its message', () {
    expect(const AuthException(message: 'boom').message, 'boom');
  });

  test('BusinessException defaults to retryable', () {
    const exception = BusinessException(message: 'boom');
    expect(exception.retryable, isTrue);
  });

  test('BusinessException can be marked as non-retryable', () {
    const exception = BusinessException(message: 'boom', retryable: false);
    expect(exception.retryable, isFalse);
  });

  test('toString returns the runtime type', () {
    expect(
      const NetworkException(message: 'boom').toString(),
      'NetworkException',
    );
  });
}
