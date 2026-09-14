import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/rating_option.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/review_question.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/teacher_review.dart';
import 'package:univalle_app/features/teaching_rating/domain/repositories/teaching_rating_repository.dart';
import 'package:univalle_app/features/teaching_rating/domain/usecases/submit_teacher_review_usecase.dart';

class MockTeachingRatingRepository extends Mock
    implements TeachingRatingRepository {}

void main() {
  late MockTeachingRatingRepository repository;
  late SubmitTeacherReviewUseCase useCase;

  const review = TeacherReview(
    formFields: {'id_evaluacion': '42'},
    questions: [
      ReviewQuestion(
        id: 'q1',
        category: QuestionCategory.teacher,
        question: '¿El docente explica con claridad?',
      ),
    ],
    teacherName: 'Ana Ríos',
    subjectName: 'Cálculo',
  );
  const answers = <String, RatingOption>{'q1': RatingOption.agree};

  setUp(() {
    repository = MockTeachingRatingRepository();
    useCase = SubmitTeacherReviewUseCase(repository);
  });

  test('forwards review, answers and feedback to the repository', () async {
    when(
      () => repository.submitTeacherReview(
        review: review,
        answers: answers,
        feedback: 'Excelente docente',
      ),
    ).thenAnswer((_) async => const Ok(null));

    final result = await useCase.call(
      review: review,
      answers: answers,
      feedback: 'Excelente docente',
    );

    expect(result, isA<Ok<void>>());
    verify(
      () => repository.submitTeacherReview(
        review: review,
        answers: answers,
        feedback: 'Excelente docente',
      ),
    ).called(1);
  });

  test('forwards a null feedback when none is given', () async {
    when(
      () => repository.submitTeacherReview(
        review: review,
        answers: answers,
        feedback: null,
      ),
    ).thenAnswer((_) async => const Ok(null));

    await useCase.call(review: review, answers: answers);

    verify(
      () => repository.submitTeacherReview(
        review: review,
        answers: answers,
        feedback: null,
      ),
    ).called(1);
  });

  test('propagates a failure result unchanged', () async {
    final failure = UnknownFailure(message: 'boom');
    when(
      () => repository.submitTeacherReview(
        review: review,
        answers: answers,
        feedback: null,
      ),
    ).thenAnswer((_) async => Err(failure));

    final result = await useCase.call(review: review, answers: answers);

    expect((result as Err<void>).failure, failure);
  });
}
