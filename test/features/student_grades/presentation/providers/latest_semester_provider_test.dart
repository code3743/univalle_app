import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/student_grades/presentation/providers/grades_providers.dart';
import 'package:univalle_app/features/student_grades/presentation/providers/latest_semester_provider.dart';
import 'package:univalle_app/features/student_grades/presentation/viewmodels/grades_view_model.dart';

import '../../../../helpers/container.dart';
import '../../../../helpers/session.dart';
import '../grades_fixtures.dart';

void main() {
  late MockGradesRepository repository;

  setUp(() {
    repository = MockGradesRepository();
  });

  test('is null while the grades are loading', () {
    when(() => repository.getGrades(username: 'jdoe'))
        .thenAnswer((_) async => Ok(history()));
    final container = createContainer(
      overrides: [
        signedInAs(),
        gradesRepositoryProvider.overrideWithValue(repository),
      ],
    );

    expect(container.read(latestSemesterProvider), isNull);
  });

  test('is the most recent period code once grades load', () async {
    when(() => repository.getGrades(username: 'jdoe')).thenAnswer(
      (_) async => Ok(
        history(
          periods: [
            period(period: 'FEBRERO/2023 - JUNIO/2023'),
            period(period: 'AGOSTO/2024 - DICIEMBRE/2024'),
            period(period: 'FEBRERO/2024 - JUNIO/2024'),
          ],
        ),
      ),
    );
    final container = createContainer(
      overrides: [
        signedInAs(),
        gradesRepositoryProvider.overrideWithValue(repository),
      ],
    );
    container.listen(latestSemesterProvider, (_, _) {});
    await container.read(gradesViewModelProvider.future);

    expect(container.read(latestSemesterProvider), '2024-2');
  });

  test('is null when there is no academic history', () async {
    when(() => repository.getGrades(username: 'jdoe'))
        .thenAnswer((_) async => Ok(history(periods: [])));
    final container = createContainer(
      overrides: [
        signedInAs(),
        gradesRepositoryProvider.overrideWithValue(repository),
      ],
    );
    container.listen(latestSemesterProvider, (_, _) {});
    await container.read(gradesViewModelProvider.future);

    expect(container.read(latestSemesterProvider), isNull);
  });

  test('is null when the grades fail to load', () async {
    when(() => repository.getGrades(username: 'jdoe'))
        .thenAnswer((_) async => Err(NetworkFailure(message: 'down')));
    final container = createContainer(
      overrides: [
        signedInAs(),
        gradesRepositoryProvider.overrideWithValue(repository),
      ],
    );
    container.listen(latestSemesterProvider, (_, _) {});
    await expectLater(
      container.read(gradesViewModelProvider.future),
      throwsA(isA<Failure>()),
    );

    expect(container.read(latestSemesterProvider), isNull);
  });
}
