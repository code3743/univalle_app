import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/teacher_to_rate.dart';
import 'package:univalle_app/features/teaching_rating/domain/repositories/teaching_rating_repository.dart';
import 'package:univalle_app/features/teaching_rating/domain/usecases/get_teachers_to_rate_usecase.dart';

class MockTeachingRatingRepository extends Mock
    implements TeachingRatingRepository {}

void main() {
  late MockTeachingRatingRepository repository;
  late GetTeachersToRateUseCase useCase;

  setUp(() {
    repository = MockTeachingRatingRepository();
    useCase = GetTeachersToRateUseCase(repository);
  });

  test('returns the list of teachers to rate from the repository', () async {
    const teachers = [
      TeacherToRate(
        id: '1',
        teacherName: 'Ana Ríos',
        subjectName: 'Cálculo',
        subjectCode: '101',
        group: '1',
        campusId: 'M',
        teacherId: 't1',
        teacherDocument: 'd1',
        programId: 'p1',
        programName: 'Ing. Sistemas',
        programCode: '752',
        isQualified: true,
      ),
    ];
    when(() => repository.getTeachersToRate())
        .thenAnswer((_) async => const Ok(teachers));

    final result = await useCase.call();

    expect((result as Ok<List<TeacherToRate>>).value, teachers);
    verify(() => repository.getTeachersToRate()).called(1);
  });

  test('propagates a failure result unchanged', () async {
    final failure = UnknownFailure(message: 'boom');
    when(() => repository.getTeachersToRate())
        .thenAnswer((_) async => Err(failure));

    final result = await useCase.call();

    expect((result as Err<List<TeacherToRate>>).failure, failure);
  });
}
