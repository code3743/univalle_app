import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/error/exceptions.dart';

void main() {
  test('ServerException carries an optional status code', () {
    final exception = ServerException(message: 'boom', statusCode: 500);
    expect(exception.message, 'boom');
    expect(exception.statusCode, 500);
  });

  test('NetworkException carries its message', () {
    expect(NetworkException(message: 'boom').message, 'boom');
  });

  test('CacheException carries its message', () {
    expect(CacheException(message: 'boom').message, 'boom');
  });

  test('AuthException carries its message', () {
    expect(AuthException(message: 'boom').message, 'boom');
  });

  test('BusinessException defaults to retryable', () {
    final exception = BusinessException(message: 'boom');
    expect(exception.retryable, isTrue);
  });

  test('BusinessException can be marked as non-retryable', () {
    final exception = BusinessException(message: 'boom', retryable: false);
    expect(exception.retryable, isFalse);
  });

  test('toString returns the runtime type', () {
    expect(NetworkException(message: 'boom').toString(), 'NetworkException');
  });
}
