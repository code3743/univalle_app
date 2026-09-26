import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/core/session/current_username_provider.dart';
import 'package:univalle_app/features/student_grades/domain/entities/grades.dart';
import 'package:univalle_app/features/student_grades/domain/repositories/grades_repository.dart';
import 'package:univalle_app/features/student_grades/presentation/providers/grades_providers.dart';
import 'package:univalle_app/features/student_grades/presentation/viewmodels/grades_view_model.dart';

import '../../../../helpers/container.dart';

class MockGradesRepository extends Mock implements GradesRepository {}

const _grades = Grades(
  period: '2024-1',
  average: 4.2,
  credits: 18,
  approvedPercentage: '100%',
  hasAcademicMerit: false,
  subjects: [],
);

void main() {
  late MockGradesRepository repository;

  setUp(() {
    repository = MockGradesRepository();
  });

  List<Override> overridesWith(GradesRepository repo) => [
    gradesRepositoryProvider.overrideWithValue(repo),
  ];

  test('throws a StateError when there is no active session', () async {
    final container = createContainer(overrides: overridesWith(repository));

    await expectLater(
      container.read(gradesViewModelProvider.future),
      throwsA(isA<StateError>()),
    );
  });

  test('returns the grades for the current session username', () async {
    when(() => repository.getGrades(username: 'jdoe'))
        .thenAnswer((_) async => const Ok([_grades]));
    final container = createContainer(overrides: overridesWith(repository));
    container.read(currentUsernameProvider.notifier).set('jdoe');

    final result = await container.read(gradesViewModelProvider.future);

    expect(result, [_grades]);
  });

  test('throws the failure when the repository call fails', () async {
    final failure = NetworkFailure(message: 'down');
    when(() => repository.getGrades(username: 'jdoe'))
        .thenAnswer((_) async => Err(failure));
    final container = createContainer(overrides: overridesWith(repository));
    container.read(currentUsernameProvider.notifier).set('jdoe');

    await expectLater(
      container.read(gradesViewModelProvider.future),
      throwsA(same(failure)),
    );
  });
}
