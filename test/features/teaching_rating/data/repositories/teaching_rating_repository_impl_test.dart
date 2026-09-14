import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/core/storage/auth_local_datasource.dart';
import 'package:univalle_app/features/teaching_rating/data/datasources/course_evaluation_remote_datasource.dart';
import 'package:univalle_app/features/teaching_rating/data/models/review_question_model.dart';
import 'package:univalle_app/features/teaching_rating/data/models/teacher_review_model.dart';
import 'package:univalle_app/features/teaching_rating/data/models/teacher_to_rate_model.dart';
import 'package:univalle_app/features/teaching_rating/data/repositories/teaching_rating_repository_impl.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/rating_option.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/review_question.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/teacher_review.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/teacher_to_rate.dart';

class MockCourseEvaluationRemoteDataSource extends Mock
    implements CourseEvaluationRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late MockCourseEvaluationRemoteDataSource remote;
  late MockAuthLocalDataSource credentials;
  late TeachingRatingRepositoryImpl repository;

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
    remote = MockCourseEvaluationRemoteDataSource();
    credentials = MockAuthLocalDataSource();
    repository = TeachingRatingRepositoryImpl(remote, credentials);
  });

  group('getTeachersToRate', () {
    test(
      'returns the teachers mapped to entities when credentials exist',
      () async {
        when(() => credentials.getCredentials()).thenAnswer(
          (_) async =>
              const StoredCredentials(username: 'jperez', password: 'x'),
        );
        when(
          () => remote.fetchTeachersToRate(username: 'jperez', password: 'x'),
        ).thenAnswer(
          (_) async => [
            TeacherToRateModel(
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
          ],
        );

        final result = await repository.getTeachersToRate();

        expect(result, isA<Ok<List<TeacherToRate>>>());
        expect((result as Ok<List<TeacherToRate>>).value, hasLength(1));
      },
    );

    test(
      'returns an AuthFailure when there are no saved credentials',
      () async {
        when(() => credentials.getCredentials()).thenAnswer((_) async => null);

        final result = await repository.getTeachersToRate();

        expect(
          (result as Err<List<TeacherToRate>>).failure,
          isA<AuthFailure>(),
        );
      },
    );
  });

  group('getTeacherReview', () {
    test(
      'returns the review mapped to an entity, without requiring credentials',
      () async {
        when(() => remote.fetchTeacherReview(teacher: teacher)).thenAnswer(
          (_) async => TeacherReviewModel(
            formFields: const {'id_evaluacion': '42'},
            questions: [
              ReviewQuestionModel(
                id: 'q1',
                category: QuestionCategory.teacher,
                question: '¿El docente explica con claridad?',
              ),
            ],
            teacherName: 'Ana Ríos',
            subjectName: 'Cálculo',
          ),
        );

        final result = await repository.getTeacherReview(teacher: teacher);

        expect(result, isA<Ok<TeacherReview>>());
        expect((result as Ok<TeacherReview>).value.questions, hasLength(1));
        verifyNever(() => credentials.getCredentials());
      },
    );

    test('maps a thrown AppException to a Failure', () async {
      when(() => remote.fetchTeacherReview(teacher: teacher))
          .thenThrow(const ServerException(message: 'boom', statusCode: 500));

      final result = await repository.getTeacherReview(teacher: teacher);

      expect((result as Err<TeacherReview>).failure, isA<ServerFailure>());
    });
  });

  group('submitTeacherReview', () {
    const review = TeacherReview(
      formFields: {'id_evaluacion': '42'},
      questions: [],
      teacherName: 'Ana Ríos',
      subjectName: 'Cálculo',
    );
    const answers = <String, RatingOption>{'q1': RatingOption.agree};

    test(
      'returns Ok(null) on success, without requiring credentials',
      () async {
        when(
          () => remote.submitTeacherReview(
            review: review,
            answers: answers,
            feedback: 'Excelente',
          ),
        ).thenAnswer((_) async {});

        final result = await repository.submitTeacherReview(
          review: review,
          answers: answers,
          feedback: 'Excelente',
        );

        expect(result, isA<Ok<void>>());
        verifyNever(() => credentials.getCredentials());
      },
    );

    test('maps a thrown AppException to a Failure', () async {
      when(
        () => remote.submitTeacherReview(
          review: review,
          answers: answers,
          feedback: null,
        ),
      ).thenThrow(const ServerException(message: 'boom', statusCode: 500));

      final result = await repository.submitTeacherReview(
        review: review,
        answers: answers,
      );

      expect((result as Err<void>).failure, isA<ServerFailure>());
    });
  });
}
