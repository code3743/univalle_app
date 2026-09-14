import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/student_grades/domain/entities/grades.dart';
import 'package:univalle_app/features/student_grades/domain/repositories/grades_repository.dart';
import 'package:univalle_app/features/student_grades/domain/usecases/get_grades_usecase.dart';

class MockGradesRepository extends Mock implements GradesRepository {}

void main() {
  late MockGradesRepository repository;
  late GetGradesUseCase useCase;

  setUp(() {
    repository = MockGradesRepository();
    useCase = GetGradesUseCase(repository);
  });

  test('forwards the username to the repository', () async {
    const grades = [
      Grades(
        period: 'Feb/22 – Jun/22',
        average: 4.1,
        credits: 18,
        approvedPercentage: '100%',
        hasAcademicMerit: false,
        subjects: [],
      ),
    ];
    when(() => repository.getGrades(username: 'jperez'))
        .thenAnswer((_) async => const Ok(grades));

    final result = await useCase.call(username: 'jperez');

    expect((result as Ok<List<Grades>>).value, grades);
    verify(() => repository.getGrades(username: 'jperez')).called(1);
  });

  test('propagates a failure result unchanged', () async {
    final failure = UnknownFailure(message: 'boom');
    when(() => repository.getGrades(username: 'jperez'))
        .thenAnswer((_) async => Err(failure));

    final result = await useCase.call(username: 'jperez');

    expect((result as Err<List<Grades>>).failure, failure);
  });
}
