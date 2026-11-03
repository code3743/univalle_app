import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';

import '../../../../core/constants/course_evaluation_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_exception_mapper.dart';
import '../../domain/entities/rating_option.dart';
import '../../domain/entities/teacher_review.dart';
import '../../domain/entities/teacher_to_rate.dart';
import '../../teaching_rating_strings.dart';
import '../models/teacher_review_model.dart';
import '../parsers/course_evaluation_parser.dart';
import '../models/teacher_to_rate_model.dart';

/// Scrapes evaluacioncursos.univalle.edu.co — a separate site from SIRA with
/// its own login, so every call here re-authenticates with the student's
/// SIRA credentials rather than relying on the shared SIRA session.
///
/// [fetchTeacherReview] and [submitTeacherReview] rely on the cookie set by
/// the most recent [fetchTeachersToRate] call (the shared [Dio] instance
/// keeps it for the app's lifetime), matching how the site itself expects a
/// single authenticated session to move from the assignment list into a
/// review and back.
class CourseEvaluationRemoteDataSource {
  final Dio _dio;
  final CookieJar _cookieJar;
  const CourseEvaluationRemoteDataSource(this._dio, this._cookieJar);

  Future<void> _authenticate({
    required String username,
    required String password,
  }) async {
    // The site redirects (302) to the home page whenever a session cookie
    // is already present, even if it belongs to a different account, so a
    // second login on top of one never actually switches users. Clearing
    // the jar first forces it to treat this as a fresh login attempt.
    await _cookieJar.deleteAll();

    final response = await _run(
      () => _dio.post(
        '',
        data: {
          'redirect': '',
          'usu_login_aut': username,
          'usu_password_aut': password,
          'imageField.x': '44',
          'imageField.y': '6',
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) =>
              status != null && status >= 200 && status < 400,
        ),
      ),
    );
    if (response.statusCode == 302) return;

    final message = CourseEvaluationParser.loginErrorMessage(
      CourseEvaluationParser.document(response.data as List<int>),
    );
    throw AuthException(message: message ?? TeachingRatingStrings.unavailable);
  }

  Future<List<TeacherToRateModel>> fetchTeachersToRate({
    required String username,
    required String password,
  }) async {
    await _authenticate(username: username, password: password);

    final response = await _run(
      () => _dio.get(CourseEvaluationConstants.homePath),
    );
    if (response.statusCode != 200) {
      throw const ServerException(message: TeachingRatingStrings.unavailable);
    }

    return CourseEvaluationParser.teachersToRate(
      CourseEvaluationParser.document(response.data as List<int>),
    );
  }

  Future<TeacherReviewModel> fetchTeacherReview({
    required TeacherToRate teacher,
  }) async {
    final response = await _run(
      () => _dio.post(
        CourseEvaluationConstants.homePath,
        data: {
          'ase_maa_per_codigo': teacher.programId,
          'ase_apd_asi_codigo': teacher.subjectCode,
          'apd_asi_nombre': teacher.subjectName,
          'ase_apd_agp_grupo': teacher.group,
          'ase_maa_pea_codigo': teacher.id,
          'ase_apd_sed_codigo': teacher.campusId,
          'ase_apd_doc_per_codigo': teacher.teacherId,
          'ase_apd_doc_codigo': teacher.teacherDocument,
          'ase_pra_nombre': teacher.programName,
          'ase_maa_pra_codigo': teacher.programCode,
          'accion': 'Evaluar',
        },
      ),
    );
    if (response.statusCode != 200) {
      throw const ServerException(
        message: TeachingRatingStrings.reviewUnavailable,
      );
    }

    return CourseEvaluationParser.review(
      CourseEvaluationParser.document(response.data as List<int>),
      teacherName: teacher.teacherName,
      subjectName: teacher.subjectName,
    );
  }

  Future<void> submitTeacherReview({
    required TeacherReview review,
    required Map<String, RatingOption> answers,
    String? feedback,
  }) async {
    final data = <String, String>{};
    for (var i = 0; i < review.questions.length; i++) {
      final question = review.questions[i];
      final rating = answers[question.id];
      if (rating == null) {
        throw BusinessException(
          message: TeachingRatingStrings.unansweredQuestion(i + 1),
        );
      }
      data['res_codigo$i'] = '';
      data['res_eva_codigo$i'] = '';
      data['res_cue_codigo$i'] = question.id;
      data['res_cal_codigo$i'] = '${rating.index + 1}';
    }

    final response = await _run(
      () => _dio.post(
        CourseEvaluationConstants.homePath,
        data: {
          ...review.formFields,
          ...data,
          'num_respuestacualitativa': '0',
          'eva_observacion': feedback ?? '',
          'operacion_principal': 'Nuevo',
          'Ventana': '',
          'accion': 'Enviar',
        },
      ),
    );
    if (response.statusCode != 200) {
      throw const ServerException(message: TeachingRatingStrings.submitFailed);
    }
  }

  Future<T> _run<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
