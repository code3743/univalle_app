import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

import '../../../../core/constants/course_evaluation_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_exception_mapper.dart';
import '../../domain/entities/rating_option.dart';
import '../../domain/entities/review_question.dart';
import '../../domain/entities/teacher_review.dart';
import '../../domain/entities/teacher_to_rate.dart';
import '../../teaching_rating_strings.dart';
import '../models/review_question_model.dart';
import '../models/teacher_review_model.dart';
import '../models/teacher_to_rate_model.dart';

const _qualifiedNoveltyTitle = 'El Docente ya ha sido evaluado';

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

    final document = parse(latin1.decode(response.data as List<int>));
    final message = document
        .querySelector('script')
        ?.text
        .replaceFirst("alert ('", '')
        .replaceFirst("');", '')
        .trim();
    throw AuthException(
      message: (message != null && message.isNotEmpty)
          ? message
          : TeachingRatingStrings.unavailable,
    );
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

    final document = parse(latin1.decode(response.data as List<int>));
    final teachers = <TeacherToRateModel>[];
    for (final form in document.querySelectorAll('form')) {
      final inputs = <String, String>{};
      for (final input in form.querySelectorAll('input')) {
        final name = input.attributes['name'];
        if (name == null || name.isEmpty) continue;
        inputs[name] = input.attributes['value'] ?? '';
      }
      final id = inputs['ase_maa_pea_codigo'];
      if (id == null || id.isEmpty) continue;

      final noveltyTitle = form
          .querySelector('span')
          ?.attributes['title']
          ?.trim();
      final isQualified = noveltyTitle == _qualifiedNoveltyTitle;

      teachers.add(
        TeacherToRateModel(
          id: id,
          teacherName:
              form.querySelector('span')?.text ??
              form.querySelector('label')?.text ??
              '',
          subjectName: inputs['apd_asi_nombre'] ?? '',
          subjectCode: inputs['ase_apd_asi_codigo'] ?? '',
          group: inputs['ase_apd_agp_grupo'] ?? '',
          campusId: inputs['ase_apd_sed_codigo'] ?? '',
          teacherId: inputs['ase_apd_doc_per_codigo'] ?? '',
          teacherDocument: inputs['ase_apd_doc_codigo'] ?? '',
          programId: inputs['ase_maa_per_codigo'] ?? '',
          programName: inputs['ase_pra_nombre'] ?? '',
          programCode: inputs['ase_maa_pra_codigo'] ?? '',
          isQualified: isQualified,
          novelty: (!isQualified && noveltyTitle != null) ? noveltyTitle : null,
        ),
      );
    }
    return teachers;
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

    final document = parse(latin1.decode(response.data as List<int>));

    // When SIRA has no real questionnaire configured for this assignment,
    // it returns a summary row ("Tipo encuesta: NO DEFINIDO (99)") instead
    // of the question form; `cantidadPreguntas21` is only present in the
    // real form, so its absence is the reliable signal to tell them apart.
    if (document.querySelector('input#cantidadPreguntas21') == null) {
      throw BusinessException(
        message:
            _surveyTypeMessage(document) ??
            TeachingRatingStrings.surveyNotConfigured,
        retryable: false,
      );
    }

    final form = document.querySelector('td[width="100%"]>form');
    if (form == null) {
      throw const ServerException(
        message: TeachingRatingStrings.reviewUnavailable,
      );
    }

    final formFields = <String, String>{};
    // SIRA embeds exactly 21 hidden inputs identifying this evaluation
    // (period, student, subject, teacher codes...) that must be replayed
    // verbatim on submit; anything past that is unrelated page markup.
    final hiddenInputs = form.querySelectorAll('input[type="HIDDEN"]').take(21);
    for (final input in hiddenInputs) {
      final name = input.attributes['name'];
      if (name == null || name.isEmpty) continue;
      formFields[name] = input.attributes['value'] ?? '';
    }

    final questions = [
      ..._questionsIn(
        document,
        cssClass: 'asignatura',
        category: QuestionCategory.subject,
      ),
      ..._questionsIn(
        document,
        cssClass: 'profesor',
        category: QuestionCategory.teacher,
      ),
      ..._questionsIn(
        document,
        cssClass: 'estudiante',
        category: QuestionCategory.student,
      ),
    ];

    return TeacherReviewModel(
      formFields: formFields,
      questions: questions,
      teacherName: teacher.teacherName,
      subjectName: teacher.subjectName,
    );
  }

  String? _surveyTypeMessage(Document document) {
    for (final label in document.querySelectorAll('td.normalNegroB > label')) {
      final labelText = label.text.trim();
      if (!labelText.toLowerCase().startsWith('tipo encuesta')) continue;
      final valueText = label.parent?.nextElementSibling?.text.trim();
      if (valueText == null || valueText.isEmpty) continue;
      return '$labelText $valueText';
    }
    return null;
  }

  List<ReviewQuestionModel> _questionsIn(
    Document document, {
    required String cssClass,
    required QuestionCategory category,
  }) {
    final texts = document.querySelectorAll('.$cssClass > td[size]');
    final ids = document.querySelectorAll('.$cssClass > td[size] > input');
    return [
      for (var i = 0; i < texts.length; i++)
        ReviewQuestionModel(
          id: i < ids.length ? (ids[i].attributes['value'] ?? '') : '',
          category: category,
          question: texts[i].text.trim(),
        ),
    ];
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
