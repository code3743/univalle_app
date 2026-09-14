import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/sira_constants.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/features/auth/auth_strings.dart';
import 'package:univalle_app/features/auth/data/datasources/sira_auth_remote_datasource.dart';

class MockDio extends Mock implements Dio {}

Response<List<int>> _bytesResponse(String html, {int statusCode = 200}) =>
    Response(
      requestOptions: RequestOptions(path: ''),
      statusCode: statusCode,
      data: latin1.encode(html),
    );

Response<String> _plainResponse(String text, {int statusCode = 200}) =>
    Response(
      requestOptions: RequestOptions(path: SiraConstants.resetPasswordUrl),
      statusCode: statusCode,
      data: text,
    );

void main() {
  late MockDio dio;
  late SiraAuthRemoteDataSource dataSource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue(Options());
  });

  setUp(() {
    dio = MockDio();
    dataSource = SiraAuthRemoteDataSource(dio);
  });

  group('login', () {
    test(
      'throws AuthException without a request for empty credentials',
      () async {
        await expectLater(
          () => dataSource.login(username: '', password: ''),
          throwsA(isA<AuthException>()),
        );
        verifyNever(() => dio.post(any(), data: any(named: 'data')));
      },
    );

    test('succeeds silently when SIRA redirects (valid credentials)', () async {
      when(
        () => dio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => _bytesResponse('', statusCode: 302));

      await expectLater(
        dataSource.login(username: 'jperez-3743', password: 'secret'),
        completes,
      );
    });

    test('parses the failure message from a real login error page', () async {
      final html = File('test/fixtures/auth/login_error.html')
          .readAsStringSync();
      when(
        () => dio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => _bytesResponse(html, statusCode: 200));

      await expectLater(
        dataSource.login(username: 'jperez-3743', password: 'wrong'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            'Verifique su LOGIN y CONTRASEÑA.',
          ),
        ),
      );
    });

    test(
      'accepts redirects and rejects hard failures as valid status',
      () async {
        when(
          () => dio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => _bytesResponse('', statusCode: 302));

        await dataSource.login(username: 'jperez-3743', password: 'secret');

        final options =
            verify(
                  () => dio.post(
                    any(),
                    data: any(named: 'data'),
                    options: captureAny(named: 'options'),
                  ),
                ).captured.single
                as Options;
        expect(options.validateStatus!(200), isTrue);
        expect(options.validateStatus!(302), isTrue);
        expect(options.validateStatus!(399), isTrue);
        expect(options.validateStatus!(400), isFalse);
        expect(options.validateStatus!(500), isFalse);
        expect(options.validateStatus!(null), isFalse);
      },
    );
  });

  group('logout', () {
    test('requests the SIRA logout endpoint', () async {
      when(() => dio.get(any())).thenAnswer((_) async => _bytesResponse(''));

      await dataSource.logout();

      verify(() => dio.get(SiraConstants.logoutPath)).called(1);
    });

    test('maps a DioException to an AppException', () async {
      when(() => dio.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: SiraConstants.logoutPath),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(() => dataSource.logout(), throwsA(isA<NetworkException>()));
    });
  });

  group('resetPassword', () {
    test(
      'throws AuthException without a request for an empty username',
      () async {
        await expectLater(
          () => dataSource.resetPassword(username: ''),
          throwsA(isA<AuthException>()),
        );
        verifyNever(() => dio.get(any(), options: any(named: 'options')));
      },
    );

    test(
      'fetches the csrf token and returns the masked confirmation email',
      () async {
        final formHtml = File('test/fixtures/auth/reset_password_form.html')
            .readAsStringSync();
        final successHtml = File(
          'test/fixtures/auth/reset_password_success.html',
        ).readAsStringSync();

        when(() => dio.get(any(), options: any(named: 'options')))
            .thenAnswer((_) async => _plainResponse(formHtml));
        when(
          () => dio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => _plainResponse(successHtml));

        final email = await dataSource.resetPassword(username: 'jperez-3743');

        expect(email, 'usu***ario@correounivalle.edu.co');
        final captured =
            verify(
                  () => dio.post(
                    any(),
                    data: captureAny(named: 'data'),
                    options: any(named: 'options'),
                  ),
                ).captured.single
                as Map;
        expect(
          captured['parametros[_csrf_token]'],
          'b81f83ee4b3ea839b0a0d2f822f60b56',
        );
        expect(captured['parametros[usuario]'], 'jperez-3743');
      },
    );

    test('throws when the reset form request does not return 200', () async {
      when(() => dio.get(any(), options: any(named: 'options')))
          .thenAnswer((_) async => _plainResponse('', statusCode: 500));

      expect(
        () => dataSource.resetPassword(username: 'jperez-3743'),
        throwsA(
          isA<ServerException>().having(
            (e) => e.message,
            'message',
            AuthStrings.serverNotResponding,
          ),
        ),
      );
    });

    test('throws when the reset form has no csrf token', () async {
      when(
        () => dio.get(any(), options: any(named: 'options')),
      ).thenAnswer((_) async => _plainResponse('<html><body></body></html>'));

      expect(
        () => dataSource.resetPassword(username: 'jperez-3743'),
        throwsA(
          isA<ServerException>().having(
            (e) => e.message,
            'message',
            AuthStrings.resetServiceUnavailable,
          ),
        ),
      );
    });

    test(
      'throws AuthException when the reset result page has an error',
      () async {
        final formHtml = File('test/fixtures/auth/reset_password_form.html')
            .readAsStringSync();
        when(() => dio.get(any(), options: any(named: 'options')))
            .thenAnswer((_) async => _plainResponse(formHtml));
        when(
          () => dio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => _plainResponse(
            '<html><body><div class="error">Usuario no encontrado</div></body></html>',
          ),
        );

        expect(
          () => dataSource.resetPassword(username: 'jperez-3743'),
          throwsA(
            isA<AuthException>().having(
              (e) => e.message,
              'message',
              'Usuario no encontrado',
            ),
          ),
        );
      },
    );

    test('maps a DioException to an AppException', () async {
      when(() => dio.get(any(), options: any(named: 'options'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: SiraConstants.resetPasswordUrl),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(
        () => dataSource.resetPassword(username: 'jperez-3743'),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
