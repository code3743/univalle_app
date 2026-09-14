import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/error/exception_mapper.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/core/error/failures.dart';

void main() {
  test(
    'maps ServerException to ServerFailure, preserving message and status code',
    () {
      final failure = mapExceptionToFailure(
        const ServerException(message: 'boom', statusCode: 500),
      );
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'boom');
      expect((failure as ServerFailure).statusCode, 500);
    },
  );

  test('maps NetworkException to NetworkFailure', () {
    final failure = mapExceptionToFailure(
      const NetworkException(message: 'offline'),
    );
    expect(failure, isA<NetworkFailure>());
    expect(failure.message, 'offline');
  });

  test('maps CacheException to CacheFailure', () {
    final failure = mapExceptionToFailure(
      const CacheException(message: 'no local data'),
    );
    expect(failure, isA<CacheFailure>());
    expect(failure.message, 'no local data');
  });

  test('maps AuthException to AuthFailure', () {
    final failure = mapExceptionToFailure(
      const AuthException(message: 'bad credentials'),
    );
    expect(failure, isA<AuthFailure>());
    expect(failure.message, 'bad credentials');
  });

  test('maps BusinessException to BusinessFailure, preserving retryable', () {
    final failure = mapExceptionToFailure(
      const BusinessException(message: 'no survey', retryable: false),
    );
    expect(failure, isA<BusinessFailure>());
    expect((failure as BusinessFailure).retryable, isFalse);
  });

  test('maps any other error to UnknownFailure using its toString', () {
    final failure = mapExceptionToFailure(StateError('unexpected'));
    expect(failure, isA<UnknownFailure>());
    expect(failure.message, StateError('unexpected').toString());
  });
}
