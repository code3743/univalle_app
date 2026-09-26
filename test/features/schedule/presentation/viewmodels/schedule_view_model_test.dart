import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/core/session/current_username_provider.dart';
import 'package:univalle_app/features/schedule/domain/entities/schedule_class.dart';
import 'package:univalle_app/features/schedule/domain/entities/schedule_subject.dart';
import 'package:univalle_app/features/schedule/domain/entities/weekday.dart';
import 'package:univalle_app/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:univalle_app/features/schedule/presentation/providers/schedule_providers.dart';
import 'package:univalle_app/features/schedule/presentation/viewmodels/schedule_view_model.dart';
import 'package:univalle_app/features/student_grades/domain/entities/grades.dart';
import 'package:univalle_app/features/student_grades/domain/entities/subject.dart';
import 'package:univalle_app/features/student_grades/domain/repositories/grades_repository.dart';
import 'package:univalle_app/features/student_grades/presentation/providers/grades_providers.dart';

import '../../../../helpers/container.dart';

class MockScheduleRepository extends Mock implements ScheduleRepository {}

class MockGradesRepository extends Mock implements GradesRepository {}

Grades _grades(List<Subject> subjects) => Grades(
  period: '2024-1',
  average: 4.0,
  credits: 18,
  approvedPercentage: '100%',
  hasAcademicMerit: false,
  subjects: subjects,
);

const _enrolledSubject = Subject(
  code: '101',
  group: '01',
  name: 'Cálculo',
  credits: 4,
  grade: '',
  isCanceled: false,
  campusId: '1',
);

void main() {
  late MockScheduleRepository scheduleRepository;
  late MockGradesRepository gradesRepository;

  setUp(() {
    scheduleRepository = MockScheduleRepository();
    gradesRepository = MockGradesRepository();
  });

  List<Override> overridesWith({
    required ScheduleRepository schedule,
    required GradesRepository grades,
  }) => [
    scheduleRepositoryProvider.overrideWithValue(schedule),
    gradesRepositoryProvider.overrideWithValue(grades),
  ];

  test('returns an empty schedule when there are no grading periods', () async {
    when(() => gradesRepository.getGrades(username: 'jdoe'))
        .thenAnswer((_) async => const Ok([]));
    final container = createContainer(
      overrides: overridesWith(
        schedule: scheduleRepository,
        grades: gradesRepository,
      ),
    );
    container.read(currentUsernameProvider.notifier).set('jdoe');

    final result = await container.read(scheduleViewModelProvider.future);

    expect(result, isEmpty);
    verifyNever(
      () => scheduleRepository.getSchedule(subjects: any(named: 'subjects')),
    );
  });

  test('returns an empty schedule when the latest period has no lookup-able subjects', () async {
    const canceled = Subject(
      code: '102',
      group: '01',
      name: 'Física',
      credits: 4,
      grade: '',
      isCanceled: true,
      campusId: '1',
    );
    when(() => gradesRepository.getGrades(username: 'jdoe')).thenAnswer(
      (_) async => Ok([
        _grades([canceled]),
      ]),
    );
    final container = createContainer(
      overrides: overridesWith(
        schedule: scheduleRepository,
        grades: gradesRepository,
      ),
    );
    container.read(currentUsernameProvider.notifier).set('jdoe');

    final result = await container.read(scheduleViewModelProvider.future);

    expect(result, isEmpty);
    verifyNever(
      () => scheduleRepository.getSchedule(subjects: any(named: 'subjects')),
    );
  });

  test(
    'fetches the schedule for the latest period\'s enrolled subjects',
    () async {
      when(() => gradesRepository.getGrades(username: 'jdoe')).thenAnswer(
        (_) async => Ok([
          _grades([_enrolledSubject]),
        ]),
      );
      const scheduleClass = ScheduleClass(
        subjectCode: '101',
        subjectName: 'Cálculo',
        group: '01',
        teacher: 'Prof',
        day: Weekday.monday,
        startTime: '08:00',
        endTime: '10:00',
        building: 'B13',
        room: '201',
        campus: 'Meléndez',
      );
      when(
        () => scheduleRepository.getSchedule(subjects: any(named: 'subjects')),
      ).thenAnswer((_) async => const Ok([scheduleClass]));
      final container = createContainer(
        overrides: overridesWith(
          schedule: scheduleRepository,
          grades: gradesRepository,
        ),
      );
      container.read(currentUsernameProvider.notifier).set('jdoe');

      final result = await container.read(scheduleViewModelProvider.future);

      expect(result, [scheduleClass]);
      final captured = verify(
        () => scheduleRepository.getSchedule(
          subjects: captureAny(named: 'subjects'),
        ),
      ).captured;
      final subjects = captured.single as List<ScheduleSubject>;
      expect(subjects, hasLength(1));
      expect(subjects.single.code, '101');
      expect(subjects.single.group, '01');
      expect(subjects.single.campusId, '1');
      expect(subjects.single.name, 'Cálculo');
    },
  );

  test('throws the failure when fetching the schedule fails', () async {
    when(() => gradesRepository.getGrades(username: 'jdoe')).thenAnswer(
      (_) async => Ok([
        _grades([_enrolledSubject]),
      ]),
    );
    final failure = NetworkFailure(message: 'down');
    when(() => scheduleRepository.getSchedule(subjects: any(named: 'subjects')))
        .thenAnswer((_) async => Err(failure));
    final container = createContainer(
      overrides: overridesWith(
        schedule: scheduleRepository,
        grades: gradesRepository,
      ),
    );
    container.read(currentUsernameProvider.notifier).set('jdoe');

    await expectLater(
      container.read(scheduleViewModelProvider.future),
      throwsA(same(failure)),
    );
  });
}
