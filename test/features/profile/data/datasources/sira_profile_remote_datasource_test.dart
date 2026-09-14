import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/sira_constants.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/features/profile/data/datasources/sira_profile_remote_datasource.dart';

class MockDio extends Mock implements Dio {}

// The academic-record half of fetchStudent hits the same "Generar Carpeta"
// report as student_grades, so that already-captured fixture is reused here
// instead of recapturing the same page.
const _academicRecordFixture =
    'test/fixtures/student_grades/academic_record_report.html';
const _contactInfoFixture = 'test/fixtures/profile/contact_info.html';

const _academicRecordFormHtml = '''
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
  late SiraProfileRemoteDataSource dataSource;
  late String contactInfoHtml;
  late String academicRecordHtml;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    contactInfoHtml = File(_contactInfoFixture).readAsStringSync();
    academicRecordHtml = File(_academicRecordFixture).readAsStringSync();
  });

  setUp(() {
    dio = MockDio();
    dataSource = SiraProfileRemoteDataSource(dio);
  });

  void stubFetchStudent({int? contactInfoStatusCode, int? recordStatusCode}) {
    when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer((
      invocation,
    ) async {
      final data = invocation.namedArguments[#data];
      if (data is Map && data['accion'] == 'desplegarFmInformacionDeContacto') {
        return _htmlResponse(
          contactInfoHtml,
          statusCode: contactInfoStatusCode ?? 200,
        );
      }
      if (data is Map && data['accion'] == 'Generar Carpeta') {
        return _htmlResponse(
          academicRecordHtml,
          statusCode: recordStatusCode ?? 200,
        );
      }
      return _htmlResponse(_academicRecordFormHtml);
    });
  }

  group('fetchStudent', () {
    test(
      'combines the contact info and academic record pages into a student',
      () async {
        stubFetchStudent();

        final student = await dataSource.fetchStudent(username: '0000000-3743');

        expect(student.documentId, '000000000');
        expect(student.firstName, 'PRUEBA');
        expect(student.lastName, 'ESTUDIANTE');
        expect(student.email, 'estudiante.prueba@correounivalle.edu.co');
        expect(student.programName, 'INGENIERÍA DE SISTEMAS');
        expect(student.campus, 'Tuluá');
        expect(student.average, 4.38);
        expect(student.accumulatedCredits, 157);
      },
    );

    test('throws when the contact info request does not return 200', () async {
      stubFetchStudent(contactInfoStatusCode: 500);

      expect(
        () => dataSource.fetchStudent(username: '0000000-3743'),
        throwsA(isA<ServerException>()),
      );
    });

    test(
      'throws when the academic record request does not return 200',
      () async {
        stubFetchStudent(recordStatusCode: 500);

        expect(
          () => dataSource.fetchStudent(username: '0000000-3743'),
          throwsA(isA<ServerException>()),
        );
      },
    );

    test('throws an AuthException when the contact info page has no name (expired session)', () async {
      when(() => dio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => _htmlResponse('<html><body></body></html>'));

      expect(
        () => dataSource.fetchStudent(username: '0000000-3743'),
        throwsA(isA<AuthException>()),
      );
    });

    test('maps a DioException to an AppException', () async {
      when(() => dio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: SiraConstants.studentPath),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(
        () => dataSource.fetchStudent(username: '0000000-3743'),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
