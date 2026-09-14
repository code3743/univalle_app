import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/core/constants/sira_constants.dart';
import 'package:univalle_app/features/student_grades/data/datasources/sira_grades_remote_datasource.dart';
import 'package:univalle_app/features/student_grades/student_grades_strings.dart';

class MockDio extends Mock implements Dio {}

// The academic-record flow is a two-step SIRA form dance: a first POST
// returns a page whose hidden <form> inputs must be echoed back verbatim in
// a second POST to actually generate the report. Only the report's content
// is parsing-relevant, so the intermediate form page is a small synthetic
// stub rather than a captured fixture.
const _formPageHtml = '''
<html><body>
  <form>
    <input type="hidden" name="ventana" value="carpeta">
  </form>
</body></html>
''';

Response<List<int>> _htmlResponse(String html, {int statusCode = 200}) =>
    Response(
      requestOptions: RequestOptions(path: SiraConstants.academicRecordPath),
      statusCode: statusCode,
      data: latin1.encode(html),
    );

void main() {
  late MockDio dio;
  late SiraGradesRemoteDataSource dataSource;
  late String reportHtml;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    reportHtml = File(
      'test/fixtures/student_grades/academic_record_report.html',
    ).readAsStringSync();
  });

  setUp(() {
    dio = MockDio();
    dataSource = SiraGradesRemoteDataSource(dio);
  });

  void stubReport({int statusCode = 200}) {
    when(() => dio.post(any(), data: any(named: 'data')))
        .thenAnswer((invocation) async {
          final data = invocation.namedArguments[#data];
          if (data is Map && data['accion'] == 'Generar Carpeta') {
            return _htmlResponse(reportHtml, statusCode: statusCode);
          }
          return _htmlResponse(_formPageHtml);
        });
  }

  group('fetchGrades', () {
    test('parses every period from a real SIRA academic record', () async {
      stubReport();

      final grades = await dataSource.fetchGrades(username: '0000000-3743');

      expect(grades, hasLength(10));
    });

    test('parses a completed period\'s summary and subjects', () async {
      stubReport();

      final grades = await dataSource.fetchGrades(username: '0000000-3743');

      final first = grades.first;
      expect(first.period, 'FEBRERO/2022 - JUNIO/2022');
      expect(first.average, 4.5);
      expect(first.credits, 18);
      expect(first.approvedPercentage, '100%');
      expect(first.hasAcademicMerit, isFalse);

      final subject = first.subjects.firstWhere((s) => s.code == '111007M');
      expect(subject.group, '50');
      expect(subject.campusId, '06');
      expect(subject.name, 'MATEMÁTICA FUNDAMENTAL');
      expect(subject.credits, 3);
      expect(subject.grade, '4.9');
      expect(subject.isCanceled, isFalse);
    });

    test('flags a period with an academic merit distinction', () async {
      stubReport();

      final grades = await dataSource.fetchGrades(username: '0000000-3743');

      expect(grades[1].period, 'AGOSTO/2022 - DICIEMBRE/2022');
      expect(grades[1].hasAcademicMerit, isTrue);
    });

    test('marks a subject canceled mid-semester with a blank grade', () async {
      stubReport();

      final grades = await dataSource.fetchGrades(username: '0000000-3743');

      final canceledPeriod = grades[5];
      expect(canceledPeriod.period, 'AGOSTO/2024 - DICIEMBRE/2024');

      final canceled = canceledPeriod.subjects.firstWhere(
        (s) => s.code == '750023C' && s.group == '51',
      );
      expect(canceled.grade, '');
      expect(canceled.isCanceled, isTrue);
    });

    test(
      'parses the in-progress current period with no final average',
      () async {
        stubReport();

        final grades = await dataSource.fetchGrades(username: '0000000-3743');

        final current = grades.last;
        expect(current.period, 'AGOSTO/2026 - DICIEMBRE/2026');
        expect(current.average, 0);
        // SIRA renders this cell without a trailing '%' for the still-open
        // in-progress period, unlike completed periods (e.g. "100%").
        expect(current.approvedPercentage, '0');

        final inProgress = current.subjects.firstWhere(
          (s) => s.code == '750039C',
        );
        expect(inProgress.name, 'TRABAJO DE GRADO II');
        expect(inProgress.grade, '');
        expect(inProgress.isCanceled, isFalse);
      },
    );

    test('throws when the report request does not return 200', () async {
      stubReport(statusCode: 500);

      expect(
        () => dataSource.fetchGrades(username: '0000000-3743'),
        throwsA(
          isA<ServerException>().having(
            (e) => e.message,
            'message',
            StudentGradesStrings.gradesUnavailable,
          ),
        ),
      );
    });

    test('maps a DioException to an AppException', () async {
      when(() => dio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(
            path: SiraConstants.academicRecordPath,
          ),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(
        () => dataSource.fetchGrades(username: '0000000-3743'),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
