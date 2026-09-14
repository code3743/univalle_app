import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/library_constants.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/features/library/data/datasources/library_remote_datasource.dart';
import 'package:univalle_app/features/library/library_strings.dart';

class MockDio extends Mock implements Dio {}

Response<String> _stringResponse(String html, {int statusCode = 200}) =>
    Response(
      requestOptions: RequestOptions(path: ''),
      statusCode: statusCode,
      data: html,
    );

void main() {
  late MockDio dio;
  late CookieJar cookieJar;
  late LibraryRemoteDataSource dataSource;
  late String sessionHtml;
  late String accountHtml;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue(Options());
    sessionHtml = File('test/fixtures/library/opac_session.html')
        .readAsStringSync();
    accountHtml = File('test/fixtures/library/opac_account.html')
        .readAsStringSync();
  });

  setUp(() {
    dio = MockDio();
    cookieJar = CookieJar();
    dataSource = LibraryRemoteDataSource(dio, cookieJar);
  });

  void stubAuthAndAccount({
    String? sessionResponse,
    String? loginResponse,
    String? accountResponse,
  }) {
    // A single stub routes by path: the home page GET (`_dio.get('')`)
    // passes no `options` while the account page GET does, and mocktail's
    // `any(named: 'options')` matches both shapes — registering them as two
    // separate stubs makes whichever is registered last silently win for
    // every call, home page included.
    when(() => dio.get(any(), options: any(named: 'options')))
        .thenAnswer((invocation) async {
          final path = invocation.positionalArguments[0] as String;
          if (path == LibraryConstants.accountPath) {
            return _stringResponse(accountResponse ?? accountHtml);
          }
          return _stringResponse(sessionResponse ?? sessionHtml);
        });
    when(
      () => dio.post(
        any(),
        data: any(named: 'data'),
        options: any(named: 'options'),
      ),
    ).thenAnswer(
      (_) async =>
          _stringResponse(loginResponse ?? '<html><body></body></html>'),
    );
  }

  group('fetchAccount', () {
    test('parses the fine and loan history from a real OPAC account', () async {
      stubAuthAndAccount();

      final account = await dataSource.fetchAccount(username: '0000000-3743');

      expect(account.currentFine, '0.00');
      expect(account.currentLoans, isEmpty);
      expect(account.history, hasLength(4));

      final first = account.history.first;
      expect(first.code, '0579289');
      // OPAC's own title data has this stray space before the accented
      // vowel ("Ingenier ía" instead of "Ingeniería") — captured verbatim.
      expect(first.title, 'Ingenier ía de software');
      expect(first.location, 'Biblioteca Sede Tulua');
      expect(first.date, '20-Mar-2026 16:53');
    });

    test(
      'accepts redirects and rejects hard failures as valid status',
      () async {
        stubAuthAndAccount();

        await dataSource.fetchAccount(username: '0000000-3743');

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
        expect(options.validateStatus!(399), isTrue);
        expect(options.validateStatus!(400), isFalse);
        expect(options.validateStatus!(null), isFalse);
      },
    );

    test('throws when the home page has no SessionID script', () async {
      stubAuthAndAccount(sessionResponse: '<html><body></body></html>');

      expect(
        () => dataSource.fetchAccount(username: '0000000-3743'),
        throwsA(
          isA<ServerException>().having(
            (e) => e.message,
            'message',
            LibraryStrings.noSessionId,
          ),
        ),
      );
    });

    test('throws AuthException when the login response has an error', () async {
      stubAuthAndAccount(
        loginResponse: '<html><body><div class="loginForm">Credenciales inválidas</div></body></html>',
      );

      expect(
        () => dataSource.fetchAccount(username: '0000000-3743'),
        throwsA(isA<AuthException>()),
      );
    });

    test('throws when the account page has no fine field', () async {
      stubAuthAndAccount(accountResponse: '<html><body></body></html>');

      expect(
        () => dataSource.fetchAccount(username: '0000000-3743'),
        throwsA(isA<ServerException>()),
      );
    });

    test('clears cookies and rethrows when a step fails', () async {
      stubAuthAndAccount(accountResponse: '<html><body></body></html>');

      await expectLater(
        () => dataSource.fetchAccount(username: '0000000-3743'),
        throwsA(isA<ServerException>()),
      );

      final cookies = await cookieJar.loadForRequest(
        Uri.parse(LibraryConstants.baseUrl),
      );
      expect(cookies, isEmpty);
    });

    test('maps a DioException to an AppException', () async {
      when(() => dio.get(any(), options: any(named: 'options'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(
        () => dataSource.fetchAccount(username: '0000000-3743'),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
