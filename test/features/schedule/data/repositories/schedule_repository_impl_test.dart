import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/schedule/data/datasources/sira_schedule_remote_datasource.dart';
import 'package:univalle_app/features/schedule/data/models/schedule_class_model.dart';
import 'package:univalle_app/features/schedule/data/repositories/schedule_repository_impl.dart';
import 'package:univalle_app/features/schedule/domain/entities/schedule_class.dart';
import 'package:univalle_app/features/schedule/domain/entities/schedule_subject.dart';
import 'package:univalle_app/features/schedule/domain/entities/weekday.dart';

class MockSiraScheduleRemoteDataSource extends Mock
    implements SiraScheduleRemoteDataSource {}

void main() {
  late MockSiraScheduleRemoteDataSource remote;
  late ScheduleRepositoryImpl repository;

  const subjects = [
    ScheduleSubject(code: '101', group: '1', campusId: 'M', name: 'Cálculo'),
  ];

  setUp(() {
    remote = MockSiraScheduleRemoteDataSource();
    repository = ScheduleRepositoryImpl(remote);
  });

  test('returns the classes mapped to entities', () async {
    when(() => remote.fetchSchedule(subjects: subjects)).thenAnswer(
      (_) async => const [
        ScheduleClassModel(
          subjectCode: '101',
          subjectName: 'Cálculo',
          group: '1',
          teacher: 'Ana Ríos',
          day: Weekday.monday,
          startTime: '07:00',
          endTime: '09:00',
          building: 'B13',
          room: '101',
          campus: 'Meléndez',
        ),
      ],
    );

    final result = await repository.getSchedule(subjects: subjects);

    expect(result, isA<Ok<List<ScheduleClass>>>());
    expect((result as Ok<List<ScheduleClass>>).value, hasLength(1));
  });

  test('maps a thrown AppException to a Failure', () async {
    when(() => remote.fetchSchedule(subjects: subjects))
        .thenThrow(const ServerException(message: 'boom', statusCode: 500));

    final result = await repository.getSchedule(subjects: subjects);

    expect((result as Err<List<ScheduleClass>>).failure, isA<ServerFailure>());
  });
}
