import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/core/network/dio_exception_mapper.dart';

RequestOptions _options() => RequestOptions(path: '/test');

void main() {
  group('timeout and connection errors', () {
    for (final type in [
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.connectionError,
    ]) {
      test('$type maps to NetworkException', () {
        final result = mapDioException(
          DioException(
            requestOptions: _options(),
            type: type,
            message: 'timed out',
          ),
        );
        expect(result, isA<NetworkException>());
        expect(result.message, 'timed out');
      });
    }

    test('falls back to a default message when none is provided', () {
      final result = mapDioException(
        DioException(
          requestOptions: _options(),
          type: DioExceptionType.connectionError,
        ),
      );
      expect(result.message, 'Connection error');
    });
  });

  group('badResponse', () {
    test('maps to ServerException using the response body and status code', () {
      final result = mapDioException(
        DioException(
          requestOptions: _options(),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: _options(),
            statusCode: 404,
            data: 'not found',
          ),
        ),
      );
      expect(result, isA<ServerException>());
      expect(result.message, 'not found');
      expect((result as ServerException).statusCode, 404);
    });

    test(
      'falls back to the exception message when the response has no data',
      () {
        final result = mapDioException(
          DioException(
            requestOptions: _options(),
            type: DioExceptionType.badResponse,
            message: 'bad response',
            response: Response(requestOptions: _options(), statusCode: 500),
          ),
        );
        expect(result.message, 'bad response');
      },
    );
  });

  group('other exception types', () {
    for (final type in [
      DioExceptionType.cancel,
      DioExceptionType.badCertificate,
      DioExceptionType.unknown,
    ]) {
      test('$type maps to ServerException', () {
        final result = mapDioException(
          DioException(requestOptions: _options(), type: type, message: 'oops'),
        );
        expect(result, isA<ServerException>());
        expect(result.message, 'oops');
      });
    }
  });
}
