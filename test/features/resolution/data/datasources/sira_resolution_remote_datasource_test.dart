import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/sira_constants.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/features/resolution/data/datasources/sira_resolution_remote_datasource.dart';

class MockDio extends Mock implements Dio {}

Response<List<int>> _htmlResponse(String html) => Response(
  requestOptions: RequestOptions(path: SiraConstants.resolutionPath),
  statusCode: 200,
  data: latin1.encode(html),
);

void main() {
  late MockDio dio;
  late SiraResolutionRemoteDataSource dataSource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    dio = MockDio();
    dataSource = SiraResolutionRemoteDataSource(dio);
  });

  group('fetchCurriculum', () {
    test('parses every subject in a real curriculum resolution', () async {
      final html = File('test/fixtures/resolution/curriculum.html')
          .readAsStringSync();
      when(() => dio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => _htmlResponse(html));

      final subjects = await dataSource.fetchCurriculum(
        username: '0000000-3743',
      );

      expect(subjects, hasLength(44));
    });

    test('parses a subject with no prerequisites', () async {
      final html = File('test/fixtures/resolution/curriculum.html')
          .readAsStringSync();
      when(() => dio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => _htmlResponse(html));

      final subjects = await dataSource.fetchCurriculum(
        username: '0000000-3743',
      );

      final subject = subjects.firstWhere((s) => s.code == '111023C');
      expect(subject.semester, 1);
      expect(subject.name, 'MATEMÁTICAS BÁSICAS');
      expect(subject.subjectType, 'AB');
      expect(subject.credits, 3);
      expect(subject.prerequisiteCodes, isEmpty);
    });

    test(
      'merges a subject repeated once per prerequisite into one entry',
      () async {
        final html = File('test/fixtures/resolution/curriculum.html')
            .readAsStringSync();
        when(() => dio.post(any(), data: any(named: 'data')))
            .thenAnswer((_) async => _htmlResponse(html));

        final subjects = await dataSource.fetchCurriculum(
          username: '0000000-3743',
        );

        final subject = subjects.firstWhere((s) => s.code == '750016C');
        expect(subject.semester, 5);
        expect(subject.name, 'SIMULACIÓN Y COMPUTACIÓN NUMÉRICA');
        expect(
          subject.prerequisiteCodes,
          unorderedEquals(['106012C', '111026C', '111048M', '761001C']),
        );
      },
    );

    test('throws when the resolution table is empty', () async {
      when(() => dio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => _htmlResponse('<html><body></body></html>'));

      expect(
        () => dataSource.fetchCurriculum(username: '0000000-3743'),
        throwsA(isA<ServerException>()),
      );
    });

    test('maps a DioException to an AppException', () async {
      when(() => dio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: SiraConstants.resolutionPath),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(
        () => dataSource.fetchCurriculum(username: '0000000-3743'),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
