import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/course_evaluation_constants.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/features/teaching_rating/data/datasources/course_evaluation_remote_datasource.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/rating_option.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/review_question.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/teacher_review.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/teacher_to_rate.dart';
import 'package:univalle_app/features/teaching_rating/teaching_rating_strings.dart';

class MockDio extends Mock implements Dio {}

Response<List<int>> _htmlResponse(String html, {int statusCode = 200}) =>
    Response(
      requestOptions: RequestOptions(path: CourseEvaluationConstants.homePath),
      statusCode: statusCode,
      data: latin1.encode(html),
    );

const _teacher = TeacherToRate(
  id: '202608041',
  teacherName: 'DOCENTE PRUEBA DOS',
  subjectName: 'COMPRENSIÓN Y PRODUCCIÓN DE TEXTOS ACADÉMICOS GENERALES',
  subjectCode: '204133C',
  group: '51',
  campusId: '06',
  teacherId: '1000000002',
  teacherDocument: '0000000001',
  programId: '1000000004',
  programName: 'TECNOLOGÍA EN DESARROLLO DE SOFTWARE',
  programCode: '2724',
  isQualified: false,
);

void main() {
  late MockDio dio;
  late CookieJar cookieJar;
  late CourseEvaluationRemoteDataSource dataSource;
  late String teachersHtml;
  late String questionsHtml;
  late String notConfiguredHtml;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue(Options());
    teachersHtml = File('test/fixtures/teaching_rating/teachers_to_rate.html')
        .readAsStringSync();
    questionsHtml = File(
      'test/fixtures/teaching_rating/teacher_review_questions.html',
    ).readAsStringSync();
    notConfiguredHtml = File(
      'test/fixtures/teaching_rating/teacher_review_not_configured.html',
    ).readAsStringSync();
  });

  setUp(() {
    dio = MockDio();
    cookieJar = CookieJar();
    dataSource = CourseEvaluationRemoteDataSource(dio, cookieJar);
  });

  void stubLogin({int statusCode = 302}) {
    when(
      () => dio.post(
        any(),
        data: any(named: 'data'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async => _htmlResponse('', statusCode: statusCode));
  }

  group('fetchTeachersToRate', () {
    test('parses the pending teacher from a real assignment list', () async {
      stubLogin();
      when(() => dio.get(any()))
          .thenAnswer((_) async => _htmlResponse(teachersHtml));

      final teachers = await dataSource.fetchTeachersToRate(
        username: 'jperez-3743',
        password: 'secret',
      );

      expect(teachers, hasLength(1));
      final teacher = teachers.single;
      expect(teacher.teacherName, 'DOCENTE PRUEBA UNO');
      expect(teacher.subjectName, 'TRABAJO DE GRADO II');
      expect(teacher.subjectCode, '750039C');
      expect(teacher.group, '54');
      expect(teacher.campusId, '06');
      expect(teacher.teacherDocument, '0000000000');
      expect(teacher.programCode, '3743');
      expect(teacher.isQualified, isFalse);
      expect(teacher.novelty, isNull);
    });

    test(
      'flags an already-qualified teacher and carries a novelty reason',
      () async {
        stubLogin();
        when(() => dio.get(any())).thenAnswer(
          (_) async => _htmlResponse('''
<html><body>
<form>
  <span title="El Docente ya ha sido evaluado">DOCENTE CALIFICADO</span>
  <input type="hidden" name="ase_maa_pea_codigo" value="111">
  <input type="hidden" name="apd_asi_nombre" value="MATERIA A">
  <input type="hidden" name="ase_apd_asi_codigo" value="000A">
  <input type="hidden" name="ase_apd_agp_grupo" value="01">
  <input type="hidden" name="ase_apd_sed_codigo" value="06">
</form>
<form>
  <span title="Periodo de evaluación cerrado">DOCENTE CON NOVEDAD</span>
  <input type="hidden" name="ase_maa_pea_codigo" value="222">
  <input type="hidden" name="apd_asi_nombre" value="MATERIA B">
  <input type="hidden" name="ase_apd_asi_codigo" value="000B">
  <input type="hidden" name="ase_apd_agp_grupo" value="02">
  <input type="hidden" name="ase_apd_sed_codigo" value="06">
</form>
</body></html>
'''),
        );

        final teachers = await dataSource.fetchTeachersToRate(
          username: 'jperez-3743',
          password: 'secret',
        );

        expect(teachers, hasLength(2));
        final qualified = teachers.firstWhere((t) => t.id == '111');
        expect(qualified.isQualified, isTrue);
        expect(qualified.novelty, isNull);

        final withNovelty = teachers.firstWhere((t) => t.id == '222');
        expect(withNovelty.isQualified, isFalse);
        expect(withNovelty.novelty, 'Periodo de evaluación cerrado');
      },
    );

    test(
      'accepts redirects and rejects hard failures as valid status',
      () async {
        stubLogin();
        when(() => dio.get(any()))
            .thenAnswer((_) async => _htmlResponse(teachersHtml));

        await dataSource.fetchTeachersToRate(
          username: 'jperez-3743',
          password: 'secret',
        );

        final options =
            verify(
                  () => dio.post(
                    any(),
                    data: any(named: 'data'),
                    options: captureAny(named: 'options'),
                  ),
                ).captured.single
                as Options;
        expect(options.validateStatus!(200), isTrue);
        expect(options.validateStatus!(399), isTrue);
        expect(options.validateStatus!(400), isFalse);
        expect(options.validateStatus!(null), isFalse);
      },
    );

    test('parses the real alert() message from a rejected login', () async {
      stubLogin(statusCode: 200);
      when(
        () => dio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => _htmlResponse(
          "<html><body><script>alert ('Usuario o clave incorrectos');</script></body></html>",
        ),
      );

      expect(
        () => dataSource.fetchTeachersToRate(
          username: 'jperez-3743',
          password: 'wrong',
        ),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            'Usuario o clave incorrectos',
          ),
        ),
      );
    });

    test('maps a DioException to an AppException', () async {
      when(
        () => dio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(
            path: CourseEvaluationConstants.homePath,
          ),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(
        () => dataSource.fetchTeachersToRate(
          username: 'jperez-3743',
          password: 'secret',
        ),
        throwsA(isA<NetworkException>()),
      );
    });

    test(
      'throws when the assignment list request does not return 200',
      () async {
        stubLogin();
        when(
          () => dio.get(any()),
        ).thenAnswer((_) async => _htmlResponse(teachersHtml, statusCode: 500));

        expect(
          () => dataSource.fetchTeachersToRate(
            username: 'jperez-3743',
            password: 'secret',
          ),
          throwsA(isA<ServerException>()),
        );
      },
    );

    test('throws AuthException when SIRA rejects the credentials', () async {
      stubLogin(statusCode: 200);
      when(() => dio.get(any())).thenAnswer((_) async => _htmlResponse(''));

      // No alert() script in the (empty) response body, so the fallback
      // message is used.
      expect(
        () => dataSource.fetchTeachersToRate(
          username: 'jperez-3743',
          password: 'wrong',
        ),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            TeachingRatingStrings.unavailable,
          ),
        ),
      );
    });
  });

  group('fetchTeacherReview', () {
    test(
      'parses all 24 questions and the 21 replay fields from a real survey',
      () async {
        when(
          () => dio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => _htmlResponse(questionsHtml));

        final review = await dataSource.fetchTeacherReview(teacher: _teacher);

        expect(review.questions, hasLength(24));
        expect(review.formFields, hasLength(21));
        expect(
          review.questions
              .where((q) => q.category == QuestionCategory.subject)
              .length,
          4,
        );
        expect(
          review.questions
              .where((q) => q.category == QuestionCategory.teacher)
              .length,
          11,
        );
        expect(
          review.questions
              .where((q) => q.category == QuestionCategory.student)
              .length,
          9,
        );

        final first = review.questions.first;
        expect(first.id, '264');
        expect(first.category, QuestionCategory.subject);
        expect(
          first.question,
          contains('se presentaron los objetivos o aprendizajes esperados'),
        );
      },
    );

    test(
      'throws a non-retryable BusinessException when no survey is configured',
      () async {
        when(
          () => dio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => _htmlResponse(notConfiguredHtml));

        expect(
          () => dataSource.fetchTeacherReview(teacher: _teacher),
          throwsA(
            isA<BusinessException>()
                .having(
                  (e) => e.message,
                  'message',
                  'Tipo encuesta: NO DEFINIDO (99)',
                )
                .having((e) => e.retryable, 'retryable', isFalse),
          ),
        );
      },
    );

    test('throws when the review request does not return 200', () async {
      when(
        () => dio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => _htmlResponse(questionsHtml, statusCode: 500));

      expect(
        () => dataSource.fetchTeacherReview(teacher: _teacher),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('submitTeacherReview', () {
    final review = TeacherReview(
      formFields: const {'ase_maa_per_codigo': '1000000004'},
      questions: const [
        ReviewQuestion(
          id: '264',
          category: QuestionCategory.subject,
          question: '¿...?',
        ),
      ],
      teacherName: _teacher.teacherName,
      subjectName: _teacher.subjectName,
    );

    test(
      'completes when every question is answered and SIRA accepts it',
      () async {
        when(
          () => dio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => _htmlResponse('', statusCode: 200));

        await expectLater(
          dataSource.submitTeacherReview(
            review: review,
            answers: {'264': RatingOption.agree},
          ),
          completes,
        );
      },
    );

    test(
      'throws BusinessException without a request for a missing answer',
      () async {
        await expectLater(
          () =>
              dataSource.submitTeacherReview(review: review, answers: const {}),
          throwsA(
            isA<BusinessException>().having(
              (e) => e.message,
              'message',
              TeachingRatingStrings.unansweredQuestion(1),
            ),
          ),
        );
        verifyNever(
          () => dio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        );
      },
    );

    test('throws when the submit request does not return 200', () async {
      when(
        () => dio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => _htmlResponse('', statusCode: 500));

      expect(
        () => dataSource.submitTeacherReview(
          review: review,
          answers: {'264': RatingOption.agree},
        ),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
