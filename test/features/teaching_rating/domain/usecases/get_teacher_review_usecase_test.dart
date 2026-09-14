import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/teacher_review.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/teacher_to_rate.dart';
import 'package:univalle_app/features/teaching_rating/domain/repositories/teaching_rating_repository.dart';
import 'package:univalle_app/features/teaching_rating/domain/usecases/get_teacher_review_usecase.dart';

class MockTeachingRatingRepository extends Mock
    implements TeachingRatingRepository {}

void main() {
  late MockTeachingRatingRepository repository;
  late GetTeacherReviewUseCase useCase;

  const teacher = TeacherToRate(
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
  );

  setUp(() {
    repository = MockTeachingRatingRepository();
    useCase = GetTeacherReviewUseCase(repository);
  });

  test('forwards the teacher to the repository', () async {
    const review = TeacherReview(
      formFields: {'id_evaluacion': '42'},
      questions: [],
      teacherName: 'Ana Ríos',
      subjectName: 'Cálculo',
    );
    when(() => repository.getTeacherReview(teacher: teacher))
        .thenAnswer((_) async => const Ok(review));

    final result = await useCase.call(teacher: teacher);

    expect((result as Ok<TeacherReview>).value, review);
    verify(() => repository.getTeacherReview(teacher: teacher)).called(1);
  });

  test('propagates a failure result unchanged', () async {
    final failure = UnknownFailure(message: 'boom');
    when(() => repository.getTeacherReview(teacher: teacher))
        .thenAnswer((_) async => Err(failure));

    final result = await useCase.call(teacher: teacher);

    expect((result as Err<TeacherReview>).failure, failure);
  });
}
