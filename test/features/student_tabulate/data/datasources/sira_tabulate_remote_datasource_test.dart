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
    when(() => dio.get<List<int>>(any())).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: <int>[],
      ),
    );
    dataSource = SiraTabulateRemoteDataSource(dio);
  });

  group('fetchTabulate', () {
    test(
      'embeds images and stylesheets fetched through the trusted Dio',
      () async {
        when(() => dio.post(any(), data: any(named: 'data')))
            .thenAnswer((_) async => _htmlResponse(reportHtml));
        when(() => dio.get<List<int>>(any())).thenAnswer((invocation) async {
          final url = invocation.positionalArguments.first as String;
          return Response(
            requestOptions: RequestOptions(path: url),
            statusCode: 200,
            data: url.endsWith('.css')
                ? utf8.encode('body{margin:0}')
                : [1, 2, 3],
          );
        });

        final result = await dataSource.fetchTabulate(username: '0000000-3743');

        expect(result, contains('src="data:image/gif;base64,AQID"'));
        expect(result, contains('<style>body{margin:0}</style>'));
        expect(result, isNot(contains('estilos.css')));
        expect(result, isNot(contains('id="mobileWrapper"')));
      },
    );

    test('keeps the absolute URL when a resource cannot be fetched', () async {
      when(() => dio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => _htmlResponse(reportHtml));
      when(() => dio.get<List<int>>(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.badCertificate,
        ),
      );

      final result = await dataSource.fetchTabulate(username: '0000000-3743');

      expect(
        result,
        contains(
          'src="https://sira.univalle.edu.co/sra/paquetes/gui/temas/'
          'univalleRojoAmarillo/imagenes/logo.gif"',
        ),
      );
      expect(
        result,
        contains(
          'href="https://sira.univalle.edu.co/sra/paquetes/gui/temas/'
          'univalleRojoAmarillo/estilos.css"',
        ),
      );
    });

    test(
      'fits the fixed-width report to the screen with a viewport meta',
      () async {
        when(() => dio.post(any(), data: any(named: 'data')))
            .thenAnswer((_) async => _htmlResponse(reportHtml));

        final result = await dataSource.fetchTabulate(username: '0000000-3743');

        expect(result, contains('name="viewport" content="width=765"'));
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
