import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/schedule_constants.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/features/schedule/data/datasources/sira_schedule_remote_datasource.dart';
import 'package:univalle_app/features/schedule/domain/entities/schedule_subject.dart';
import 'package:univalle_app/features/schedule/domain/entities/weekday.dart';

class MockDio extends Mock implements Dio {}

Response<List<int>> _htmlResponse(String html, {int statusCode = 200}) =>
    Response(
      requestOptions: RequestOptions(path: ScheduleConstants.path),
      statusCode: statusCode,
      data: latin1.encode(html),
    );

const _subjectWithSchedule = ScheduleSubject(
  code: '806010M',
  group: '01',
  campusId: '02',
  name: 'INGENIERÍA DE SOFTWARE',
);

const _subjectOtherGroup = ScheduleSubject(
  code: '806010M',
  group: '02',
  campusId: '02',
  name: 'INGENIERÍA DE SOFTWARE',
);

const _subjectUnknownGroup = ScheduleSubject(
  code: '806010M',
  group: '99',
  campusId: '02',
  name: 'INGENIERÍA DE SOFTWARE',
);

void main() {
  late MockDio dio;
  late SiraScheduleRemoteDataSource dataSource;
  late String scheduleHtml;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    scheduleHtml = File('test/fixtures/schedule/subject_schedule.html')
        .readAsStringSync();
  });

  setUp(() {
    dio = MockDio();
    dataSource = SiraScheduleRemoteDataSource(dio);
  });

  group('fetchSchedule', () {
    test(
      'parses every weekly session for a group with two class days',
      () async {
        when(() => dio.post(any(), data: any(named: 'data')))
            .thenAnswer((_) async => _htmlResponse(scheduleHtml));

        final classes = await dataSource.fetchSchedule(
          subjects: [_subjectWithSchedule],
        );

        expect(classes, hasLength(2));

        final wednesday = classes.firstWhere((c) => c.day == Weekday.wednesday);
        expect(wednesday.startTime, '14:00');
        expect(wednesday.endTime, '16:00');
        expect(wednesday.building, 'E23');
        expect(wednesday.room, '1020');
        expect(wednesday.campus, 'MELENDEZ');
        expect(wednesday.teacher, 'DOCENTE PRUEBA UNO');
        expect(wednesday.teacherEmail, 'docente.uno@correounivalle.edu.co');
        expect(wednesday.subjectCode, _subjectWithSchedule.code);
        expect(wednesday.subjectName, _subjectWithSchedule.name);
        expect(wednesday.group, _subjectWithSchedule.group);

        final monday = classes.firstWhere((c) => c.day == Weekday.monday);
        expect(monday.startTime, '14:00');
        expect(monday.endTime, '16:00');
        expect(monday.building, 'E26');
        expect(monday.room, '1017');
        expect(monday.campus, 'MELENDEZ');
      },
    );

    test(
      'parses a different group\'s own two sessions independently',
      () async {
        when(() => dio.post(any(), data: any(named: 'data')))
            .thenAnswer((_) async => _htmlResponse(scheduleHtml));

        final classes = await dataSource.fetchSchedule(
          subjects: [_subjectOtherGroup],
        );

        expect(classes, hasLength(2));
        final monday = classes.firstWhere((c) => c.day == Weekday.monday);
        expect(monday.building, 'E23');
        expect(monday.room, '1011');
        final wednesday = classes.firstWhere((c) => c.day == Weekday.wednesday);
        expect(wednesday.building, 'E20');
        expect(wednesday.room, 'SC2');
      },
    );

    test(
      'returns no sessions for a group that has no row in the table',
      () async {
        when(() => dio.post(any(), data: any(named: 'data')))
            .thenAnswer((_) async => _htmlResponse(scheduleHtml));

        final classes = await dataSource.fetchSchedule(
          subjects: [_subjectUnknownGroup],
        );

        expect(classes, isEmpty);
      },
    );

    test('throws when the response does not return 200', () async {
      when(
        () => dio.post(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => _htmlResponse(scheduleHtml, statusCode: 500));

      expect(
        () => dataSource.fetchSchedule(subjects: [_subjectWithSchedule]),
        throwsA(isA<ServerException>()),
      );
    });

    test('maps a DioException to an AppException', () async {
      when(() => dio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ScheduleConstants.path),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(
        () => dataSource.fetchSchedule(subjects: [_subjectWithSchedule]),
        throwsA(isA<NetworkException>()),
      );
    });

    // Neither format below appears in the real captured fixture, so these
    // use small synthetic rows matching the same table shape to exercise
    // the defensive/legacy parsing branches instead.
    test(
      'falls back to a next-line location when none is on the same line',
      () async {
        const subject = ScheduleSubject(
          code: '806010M',
          group: 'X1',
          campusId: '02',
          name: 'INGENIERÍA DE SOFTWARE',
        );
        when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => _htmlResponse('''
<table width="768"><tbody>
<tr>
<td>1</td><td>PERIODO</td><td>X1</td><td>10</td>
<td> JUE: 14:00-17:00 , Edf. B13<br>(B13) -> SALA 1 -- MG -- MELENDEZ<br></td>
<td> PROFESOR SIN CORREO </td>
<td>Programa</td><td></td><td></td>
</tr>
</tbody></table>
'''),
        );

        final classes = await dataSource.fetchSchedule(subjects: [subject]);

        expect(classes, hasLength(1));
        expect(classes.single.building, 'B13');
        expect(classes.single.room, 'SALA 1');
        expect(classes.single.campus, 'MELENDEZ');
        expect(classes.single.teacher, 'PROFESOR SIN CORREO');
        expect(classes.single.teacherEmail, isNull);
      },
    );

    test('parses a session with no room assigned yet', () async {
      const subject = ScheduleSubject(
        code: '806010M',
        group: 'X2',
        campusId: '02',
        name: 'INGENIERÍA DE SOFTWARE',
      );
      when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => _htmlResponse('''
<table width="768"><tbody>
<tr>
<td>1</td><td>PERIODO</td><td>X2</td><td>10</td>
<td> JUE: 8:00-12:00 ,SIN ESPACIO -- MG<br></td>
<td> DOCENTE PRUEBA UNO docente.uno@correounivalle.edu.co</td>
<td>Programa</td><td></td><td></td>
</tr>
</tbody></table>
'''),
      );

      final classes = await dataSource.fetchSchedule(subjects: [subject]);

      expect(classes, hasLength(1));
      final session = classes.single;
      expect(session.day, Weekday.thursday);
      expect(session.startTime, '08:00');
      expect(session.endTime, '12:00');
      expect(session.building, '');
      expect(session.room, '');
      expect(session.campus, '');
    });

    // SIRA sometimes renders the same programming table twice in one
    // response; only the first should be parsed or every session doubles.
    test(
      'does not double sessions when SIRA repeats the table in one response',
      () async {
        const subject = ScheduleSubject(
          code: '204025C',
          group: '50',
          campusId: '06',
          name: 'INGLÉS CON FINES GENERALES Y ACADÉM. I',
        );
        const groupRow = '''
<table width="768"><tbody>
<tr>
<td>1</td><td>PERIODO</td><td>50</td><td>8</td>
<td> LUN: 18:00-22:00 ,SIN ESPACIO -- MG <br></td>
<td> DOCENTE PRUEBA UNO docente.uno@correounivalle.edu.co</td>
<td>Programa</td><td></td><td></td>
</tr>
</tbody></table>
''';
        when(() => dio.post(any(), data: any(named: 'data')))
            .thenAnswer((_) async => _htmlResponse('$groupRow\n$groupRow'));

        final classes = await dataSource.fetchSchedule(subjects: [subject]);

        expect(classes, hasLength(1));
        expect(classes.single.day, Weekday.monday);
        expect(classes.single.startTime, '18:00');
        expect(classes.single.endTime, '22:00');
      },
    );
  });
}
