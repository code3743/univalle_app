import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/constants/app_strings.dart';
import 'package:univalle_app/core/error/failures.dart';

void main() {
  group('ServerFailure', () {
    test('maps 401 to the session-expired message', () {
      final failure = ServerFailure(message: 'x', statusCode: 401);
      expect(failure.userMessage, AppStrings.sessionExpired);
    });

    test('maps 403 to the forbidden message', () {
      final failure = ServerFailure(message: 'x', statusCode: 403);
      expect(failure.userMessage, AppStrings.forbidden);
    });

    test('maps 404 to the not-found message', () {
      final failure = ServerFailure(message: 'x', statusCode: 404);
      expect(failure.userMessage, AppStrings.notFound);
    });

    test('maps any 5xx to the server-error message', () {
      expect(
        ServerFailure(message: 'x', statusCode: 500).userMessage,
        AppStrings.serverError,
      );
      expect(
        ServerFailure(message: 'x', statusCode: 503).userMessage,
        AppStrings.serverError,
      );
    });

    test(
      'maps an unrecognized status code to the generic request-error message',
      () {
        expect(
          ServerFailure(message: 'x', statusCode: 418).userMessage,
          AppStrings.requestError,
        );
      },
    );

    test('maps a null status code to the generic request-error message', () {
      expect(
        ServerFailure(message: 'x', statusCode: null).userMessage,
        AppStrings.requestError,
      );
    });
  });

  test('NetworkFailure uses the network-error message', () {
    expect(NetworkFailure(message: 'x').userMessage, AppStrings.networkError);
  });

  test('CacheFailure uses the cache-error message', () {
    expect(CacheFailure(message: 'x').userMessage, AppStrings.cacheError);
  });

  test('UnknownFailure uses the generic-error message', () {
    expect(UnknownFailure(message: 'x').userMessage, AppStrings.genericError);
  });

  test('AuthFailure surfaces its own message as the user message', () {
    expect(
      AuthFailure(message: 'Sesión inválida').userMessage,
      'Sesión inválida',
    );
  });

  test('BusinessFailure surfaces its own message as the user message and defaults to retryable', () {
    final failure = BusinessFailure(message: 'Encuesta no disponible');
    expect(failure.userMessage, 'Encuesta no disponible');
    expect(failure.retryable, isTrue);
  });

  test('BusinessFailure can be marked as non-retryable', () {
    final failure = BusinessFailure(message: 'x', retryable: false);
    expect(failure.retryable, isFalse);
  });

  test('toString includes the internal message', () {
    expect(
      NetworkFailure(message: 'boom').toString(),
      'Failure(message: boom)',
    );
  });
}
