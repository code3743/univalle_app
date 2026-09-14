import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/profile/domain/entities/student.dart';
import 'package:univalle_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:univalle_app/features/profile/domain/usecases/get_student_usecase.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository repository;
  late GetStudentUseCase useCase;

  setUp(() {
    repository = MockProfileRepository();
    useCase = GetStudentUseCase(repository);
  });

  test('forwards the username to the repository', () async {
    const student = Student(
      documentId: '123',
      firstName: 'Juan',
      lastName: 'Perez',
      email: 'jperez@correounivalle.edu.co',
      programName: 'Ingeniería de Sistemas',
      campus: 'Meléndez',
      average: 4.2,
      accumulatedCredits: 90,
    );
    when(() => repository.getStudent(username: 'jperez'))
        .thenAnswer((_) async => const Ok(student));

    final result = await useCase.call(username: 'jperez');

    expect((result as Ok<Student>).value, student);
    verify(() => repository.getStudent(username: 'jperez')).called(1);
  });

  test('propagates a failure result unchanged', () async {
    final failure = UnknownFailure(message: 'boom');
    when(() => repository.getStudent(username: 'jperez'))
        .thenAnswer((_) async => Err(failure));

    final result = await useCase.call(username: 'jperez');

    expect((result as Err<Student>).failure, failure);
  });
}
