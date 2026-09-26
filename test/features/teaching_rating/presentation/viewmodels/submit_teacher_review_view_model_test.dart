import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/rating_option.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/review_question.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/teacher_review.dart';
import 'package:univalle_app/features/teaching_rating/domain/repositories/teaching_rating_repository.dart';
import 'package:univalle_app/features/teaching_rating/presentation/providers/teaching_rating_providers.dart';
import 'package:univalle_app/features/teaching_rating/presentation/viewmodels/submit_teacher_review_view_model.dart';
import 'package:univalle_app/features/teaching_rating/teaching_rating_strings.dart';

import '../../../../helpers/container.dart';

class MockTeachingRatingRepository extends Mock
    implements TeachingRatingRepository {}

const _question1 = ReviewQuestion(
  id: 'q1',
  category: QuestionCategory.subject,
  question: '¿Pregunta 1?',
);
const _question2 = ReviewQuestion(
  id: 'q2',
  category: QuestionCategory.teacher,
  question: '¿Pregunta 2?',
);

const _review = TeacherReview(
  formFields: {'id_evaluacion': '99'},
  questions: [_question1, _question2],
  teacherName: 'Prof',
  subjectName: 'Cálculo',
);

void main() {
  late MockTeachingRatingRepository repository;

  setUpAll(() {
    registerFallbackValue(_review);
    registerFallbackValue(<String, RatingOption>{});
  });

  setUp(() {
    repository = MockTeachingRatingRepository();
  });

  List<Override> overridesWith(TeachingRatingRepository repo) => [
    teachingRatingRepositoryProvider.overrideWithValue(repo),
  ];

  test('build starts with no result', () async {
    final container = createContainer(overrides: overridesWith(repository));

    final result = await container.read(
      submitTeacherReviewViewModelProvider.future,
    );

    expect(result, isNull);
  });

  test('rejects submission locally when a question is unanswered', () async {
    final container = createContainer(overrides: overridesWith(repository));
    await container.read(submitTeacherReviewViewModelProvider.future);

    await container
        .read(submitTeacherReviewViewModelProvider.notifier)
        .submit(
          review: _review,
          answers: {'q1': RatingOption.agree},
          feedback: '',
        );

    final state = container.read(submitTeacherReviewViewModelProvider);
    expect(state, isA<AsyncError>());
    final failure = (state as AsyncError).error as BusinessFailure;
    expect(failure.message, TeachingRatingStrings.unansweredQuestion(2));
    verifyNever(
      () => repository.submitTeacherReview(
        review: any(named: 'review'),
        answers: any(named: 'answers'),
        feedback: any(named: 'feedback'),
      ),
    );
  });

  test(
    'submits and resolves to true when every question is answered',
    () async {
      final answers = {
        'q1': RatingOption.agree,
        'q2': RatingOption.totallyAgree,
      };
      when(
        () => repository.submitTeacherReview(
          review: _review,
          answers: answers,
          feedback: 'great',
        ),
      ).thenAnswer((_) async => const Ok(null));
      final container = createContainer(overrides: overridesWith(repository));
      await container.read(submitTeacherReviewViewModelProvider.future);

      await container
          .read(submitTeacherReviewViewModelProvider.notifier)
          .submit(review: _review, answers: answers, feedback: 'great');

      expect(
        container.read(submitTeacherReviewViewModelProvider).value,
        isTrue,
      );
    },
  );

  test(
    'sets an AsyncError when the repository rejects the submission',
    () async {
      final answers = {
        'q1': RatingOption.agree,
        'q2': RatingOption.totallyAgree,
      };
      when(
        () => repository.submitTeacherReview(
          review: any(named: 'review'),
          answers: any(named: 'answers'),
          feedback: any(named: 'feedback'),
        ),
      ).thenAnswer((_) async => Err(NetworkFailure(message: 'down')));
      final container = createContainer(overrides: overridesWith(repository));
      await container.read(submitTeacherReviewViewModelProvider.future);

      await container
          .read(submitTeacherReviewViewModelProvider.notifier)
          .submit(review: _review, answers: answers, feedback: '');

      expect(
        container.read(submitTeacherReviewViewModelProvider),
        isA<AsyncError>(),
      );
    },
  );
}
