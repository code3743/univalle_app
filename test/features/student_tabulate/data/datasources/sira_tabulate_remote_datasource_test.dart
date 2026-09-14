import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/sira_constants.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/features/student_tabulate/data/datasources/sira_tabulate_remote_datasource.dart';

class MockDio extends Mock implements Dio {}

Response<List<int>> _htmlResponse(String html) => Response(
  requestOptions: RequestOptions(path: SiraConstants.tabulatedPath),
  statusCode: 200,
  data: latin1.encode(html),
);

void main() {
  late MockDio dio;
  late SiraTabulateRemoteDataSource dataSource;
  late String reportHtml;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    reportHtml = File('test/fixtures/student_tabulate/tabulate_report.html')
        .readAsStringSync();
  });

  setUp(() {
    dio = MockDio();
    dataSource = SiraTabulateRemoteDataSource(dio);
  });

  group('fetchTabulate', () {
    test(
      'returns a mobile-ready document scaled from a real tabulado',
      () async {
        when(() => dio.post(any(), data: any(named: 'data')))
            .thenAnswer((_) async => _htmlResponse(reportHtml));

        final result = await dataSource.fetchTabulate(username: '0000000-3743');

        expect(result, contains('id="mobileWrapper"'));
        expect(result, contains('name="viewport"'));
        // The real fixture's frame table is 765px wide.
        expect(result, contains('calc(100vw / 765px)'));
      },
    );

    test('strips dead interactive elements and HTML comments', () async {
      when(() => dio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => _htmlResponse(reportHtml));

      final result = await dataSource.fetchTabulate(username: '0000000-3743');

      expect(result, isNot(contains('<script')));
      expect(result, isNot(contains('<form')));
      expect(result, isNot(contains('<a ')));
      expect(result, isNot(contains('<!--')));
    });

    test('drops legacy right-click-blocking body attributes', () async {
      when(() => dio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => _htmlResponse(reportHtml));

      final result = await dataSource.fetchTabulate(username: '0000000-3743');

      expect(result, isNot(contains('oncontextmenu')));
      expect(result, isNot(contains('leftmargin')));
    });

    test(
      'throws when the response has no univalle logo (unavailable)',
      () async {
        when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => _htmlResponse('<html><body>No tabulado</body></html>'),
        );

        expect(
          () => dataSource.fetchTabulate(username: '0000000-3743'),
          throwsA(isA<ServerException>()),
        );
      },
    );

    test('maps a DioException to an AppException', () async {
      when(() => dio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: SiraConstants.tabulatedPath),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(
        () => dataSource.fetchTabulate(username: '0000000-3743'),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
