import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/schedule/domain/entities/schedule_class.dart';
import 'package:univalle_app/features/schedule/domain/entities/schedule_subject.dart';
import 'package:univalle_app/features/schedule/domain/entities/weekday.dart';
import 'package:univalle_app/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:univalle_app/features/schedule/domain/usecases/get_schedule_usecase.dart';

class MockScheduleRepository extends Mock implements ScheduleRepository {}

void main() {
  late MockScheduleRepository repository;
  late GetScheduleUseCase useCase;

  const subjects = [
    ScheduleSubject(code: '101', group: '1', campusId: 'M', name: 'Cálculo'),
  ];

  setUp(() {
    repository = MockScheduleRepository();
    useCase = GetScheduleUseCase(repository);
  });

  test('forwards the subjects to the repository', () async {
    const scheduleClass = ScheduleClass(
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
    );
    when(() => repository.getSchedule(subjects: subjects))
        .thenAnswer((_) async => const Ok([scheduleClass]));

    final result = await useCase.call(subjects: subjects);

    expect((result as Ok<List<ScheduleClass>>).value, [scheduleClass]);
    verify(() => repository.getSchedule(subjects: subjects)).called(1);
  });

  test('propagates a failure result unchanged', () async {
    final failure = UnknownFailure(message: 'boom');
    when(() => repository.getSchedule(subjects: subjects))
        .thenAnswer((_) async => Err(failure));

    final result = await useCase.call(subjects: subjects);

    expect((result as Err<List<ScheduleClass>>).failure, failure);
  });
}
