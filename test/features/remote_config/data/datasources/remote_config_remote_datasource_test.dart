import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/features/remote_config/data/datasources/remote_config_remote_datasource.dart';

class MockDio extends Mock implements Dio {}

Response<Map<String, dynamic>> _jsonResponse(Map<String, dynamic> data) =>
    Response(
      requestOptions: RequestOptions(path: ''),
      statusCode: 200,
      data: data,
    );

void main() {
  late MockDio dio;
  late RemoteConfigRemoteDataSource dataSource;
  late Map<String, dynamic> configStatusJson;
  late Map<String, dynamic> modulesJson;
  late Map<String, dynamic> welcomeJson;
  late Map<String, dynamic> announcementsJson;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    configStatusJson = jsonDecode(
      File('test/fixtures/remote_config/app_config_status.json')
          .readAsStringSync(),
    ) as Map<String, dynamic>;
    modulesJson = jsonDecode(
      File('test/fixtures/remote_config/app_modules.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    welcomeJson = jsonDecode(
      File('test/fixtures/remote_config/app_welcome.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    announcementsJson = jsonDecode(
      File('test/fixtures/remote_config/announcements_page.json')
          .readAsStringSync(),
    ) as Map<String, dynamic>;
  });

  setUp(() {
    dio = MockDio();
    dataSource = RemoteConfigRemoteDataSource(dio);
  });

  void stubAllEndpoints() {
    when(
      () => dio.get(
        '/app/config',
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer((_) async => _jsonResponse(configStatusJson));
    when(
      () => dio.get(
        '/app/modules',
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer((_) async => _jsonResponse(modulesJson));
    when(() => dio.get('/app/welcome'))
        .thenAnswer((_) async => _jsonResponse(welcomeJson));
  }

  group('fetchConfig', () {
    test('fetches config, modules and welcome and merges them', () async {
      stubAllEndpoints();

      final model = await dataSource.fetchConfig(
        platform: 'android',
        version: '0.1.0',
      );

      verify(
        () => dio.get(
          '/app/config',
          queryParameters: {'platform': 'android', 'version': '0.1.0'},
        ),
      ).called(1);
      verify(
        () => dio.get('/app/modules', queryParameters: {'platform': 'android'}),
      ).called(1);
      verify(() => dio.get('/app/welcome')).called(1);

      expect(model.platformEnabled, isTrue);
      expect(model.modules, isNotEmpty);
      expect(model.quickAccess, ['grades', 'digital_card']);
      expect(model.welcome.enabled, isTrue);
    });

    test(
      'maps a DioException from any of the endpoints to an AppException',
      () {
        stubAllEndpoints();
        when(() => dio.get('/app/welcome')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        expect(
          () => dataSource.fetchConfig(platform: 'android', version: '0.1.0'),
          throwsA(isA<NetworkException>()),
        );
      },
    );
  });

  group('fetchAnnouncements', () {
    test('sends the page as a query param and parses the envelope', () async {
      when(
        () => dio.get(
          '/app/announcements',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => _jsonResponse(announcementsJson));

      final page = await dataSource.fetchAnnouncements(page: 1);

      verify(() => dio.get('/app/announcements', queryParameters: {'page': 1}))
          .called(1);
      expect(page.items, hasLength(2));
    });

    test('maps a DioException to an AppException', () {
      when(
        () => dio.get(
          '/app/announcements',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 500,
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => dataSource.fetchAnnouncements(page: 1),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
