import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/features/news/data/datasources/news_remote_datasource.dart';

class MockDio extends Mock implements Dio {}

Response<String> _stringResponse(String html) => Response(
  requestOptions: RequestOptions(path: ''),
  statusCode: 200,
  data: html,
);

void main() {
  late MockDio dio;
  late NewsRemoteDataSource dataSource;
  late String page1Html;
  late String page2Html;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    page1Html = File('test/fixtures/news/agencia_noticias_page1.html')
        .readAsStringSync();
    page2Html = File('test/fixtures/news/agencia_noticias_page2.html')
        .readAsStringSync();
  });

  setUp(() {
    dio = MockDio();
    dataSource = NewsRemoteDataSource(dio);
  });

  group('fetchNews', () {
    test('parses title, summary, image, category and absolute urls from '
        'the leading item on a real listing page', () async {
      when(() => dio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => _stringResponse(page1Html));

      final articles = await dataSource.fetchNews(page: 0);

      expect(articles, isNotEmpty);
      final first = articles.first;
      expect(
        first.title,
        'Univalle Radio entre los medios más consultados por líderes de '
        'opinión en 2026',
      );
      expect(
        first.sourceUrl,
        'https://www.univalle.edu.co/arte-y-cultura/univalle-radio-los-medios-mas-consultados-por-lideres-de-opinion-en-2026',
      );
      expect(
        first.imageUrl,
        'https://www.univalle.edu.co/media/k2/items/cache/5ed6ec283ae02d0df1756eeb95f9359a_M.jpg',
      );
      expect(first.category, 'Arte y Cultura');
      // The source HTML has a non-breaking space (" ") between
      // "Radio" and "se" here, not a regular one.
      expect(
        first.summary,
        contains('La emisora de Univalle Radio se destaca'),
      );
    });

    test('also parses secondary items, whose image lives in a nested '
        '"bloque-imagen" wrapper', () async {
      when(() => dio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => _stringResponse(page1Html));

      final articles = await dataSource.fetchNews(page: 0);

      final secondary = articles.firstWhere(
        (article) =>
            article.title ==
            'El estudio patológico de las '
                'infraestructuras',
      );
      expect(
        secondary.imageUrl,
        'https://www.univalle.edu.co/media/k2/items/cache/cbbfe09f6476751d6c431c2e323880fe_S.jpg',
      );
    });

    test('requests the "start" offset for pages after the first', () async {
      when(() => dio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => _stringResponse(page2Html));

      await dataSource.fetchNews(page: 1);

      verify(() => dio.get(any(), queryParameters: {'start': 21})).called(1);
    });

    test('omits query parameters for the first page', () async {
      when(() => dio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => _stringResponse(page1Html));

      await dataSource.fetchNews(page: 0);

      verify(() => dio.get(any(), queryParameters: null)).called(1);
    });

    test('maps a DioException to an AppException', () async {
      when(() => dio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenThrow(
            DioException(
              requestOptions: RequestOptions(path: ''),
              type: DioExceptionType.connectionTimeout,
            ),
          );

      expect(
        () => dataSource.fetchNews(page: 0),
        throwsA(isA<NetworkException>()),
      );
    });

    test('returns an empty list past the last page', () async {
      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer((_) async => _stringResponse('<html><body></body></html>'));

      final articles = await dataSource.fetchNews(page: 500);

      expect(articles, isEmpty);
    });
  });
}
