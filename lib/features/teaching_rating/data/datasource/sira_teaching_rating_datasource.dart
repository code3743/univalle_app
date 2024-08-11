import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:univalle_app/core/errors/sira_exception.dart';
import 'package:univalle_app/core/errors/handle_sira_errors.dart';
import 'package:univalle_app/config/constants/course_evaluation.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/questions_subject.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/review_subject.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/teaching_rating.dart';
import 'package:univalle_app/features/teaching_rating/data/models/teaching_rating_model.dart';
import 'package:univalle_app/features/teaching_rating/domain/datasources/teaching_rating_datasource.dart';

class SiraTeachingRatingDatasource implements TeachingRatingDatasource {
  final Dio _dio = Dio();
  final _cookieJar = CookieJar();

  SiraTeachingRatingDatasource() {
    _dio
      ..interceptors.add(CookieManager(_cookieJar))
      ..options.contentType = 'application/x-www-form-urlencoded'
      ..options.responseType = ResponseType.bytes;
  }

  Future<void> authenticateSession(String user, String password) async {
    try {
      final response = await _dio.post(CourseEvaluation.baseUrl,
          data: {
            'redirect': '',
            'usu_login_aut': user,
            'usu_password_aut': password,
            'imageField.x': '44',
            'imageField.y': '6'
          },
          options: Options(
              followRedirects: false,
              validateStatus: (status) =>
                  status != null && status >= 200 && status < 400));
      if (response.statusCode != 302) {
        final data = latin1.decode(response.data);
        final document = parse(data);
        final error = document
            .querySelector('script')
            ?.text
            .replaceFirst("alert ('", '')
            .replaceFirst("');", '')
            .trim();
        throw SiraException(error ?? 'Error al autenticar');
      }
    } catch (e) {
      throw handleSiraError(e);
    }
  }

  @override
  Future<List<TeachingRating>> getTeachingToRatings(
      String user, String password) async {
    try {
      await authenticateSession(user, password);
      final response =
          await _dio.get(CourseEvaluation.baseUrl + CourseEvaluation.homePath);
      if (response.statusCode != 200) {
        throw SiraException('No se pudo obtener la información');
      }
      final document = parse(latin1.decode(response.data));
      final forms = document.querySelectorAll('form');
      final teachers = <TeachingRating>[];
      for (final form in forms) {
        final Map<String, dynamic> data = {};

        final teacherName = form.querySelector('span')?.text ??
            form.querySelector('label')?.text ??
            '';
        final isQualified =
            form.querySelector('span')?.attributes['title']?.trim() ==
                'El Docente ya ha sido evaluado';
        data['teacherName'] = teacherName;
        data['isQualified'] = isQualified;
        if (!isQualified && form.querySelector('span') != null) {
          data['novelty'] =
              form.querySelector('span')!.attributes['title']?.trim() ??
                  'Se encontró una novedad';
        }
        form.querySelectorAll('input').forEach((element) {
          data[element.attributes['name']!] = element.attributes['value'];
        });
        teachers.add(TeachingRatingModel.fromJson(data).toEntity());
      }
      return teachers;
    } catch (e) {
      throw handleSiraError(e);
    }
  }

  @override
  Future<void> sendTeachingRating(ReviewSubject review) async {
    try {
      final Map<String, String> data = {};
      for (int i = 0; i < review.questions.length; i++) {
        data['res_codigo$i'] = '';
        data['res_eva_codigo$i'] = '';
        data['res_cue_codigo$i'] = review.questions[i].id;
        if (review.questions[i].rating == null) {
          throw SiraException('No se ha calificado la pregunta ${i + 1}');
        }
        data['res_cal_codigo$i'] = '${(review.questions[i].rating!.index) + 1}';
      }
      final response = await _dio
          .post(CourseEvaluation.baseUrl + CourseEvaluation.homePath, data: {
        ...review.bodyData,
        ...data,
        'num_respuestacualitativa': '0',
        'eva_observacion': review.feedback ?? '',
        'operacion_principal': 'Nuevo',
        'Ventana': '',
        'accion': 'Enviar'
      });
      if (response.statusCode != 200) {
        throw SiraException('No se pudo enviar la evaluación');
      }
    } catch (e) {
      throw handleSiraError(e);
    }
  }

  @override
  Future<ReviewSubject> getReviewSubject(TeachingRating teacher) async {
    try {
      final response = await _dio
          .post(CourseEvaluation.baseUrl + CourseEvaluation.homePath, data: {
        'ase_maa_per_codigo': teacher.programId,
        'ase_apd_asi_codigo': teacher.code,
        'apd_asi_nombre': teacher.subjectName,
        'ase_apd_agp_grupo': teacher.group,
        'ase_maa_pea_codigo': teacher.id,
        'ase_apd_sed_codigo': teacher.campusId,
        'ase_apd_doc_per_codigo': teacher.teacherId,
        'ase_apd_doc_codigo': teacher.teacherDocument,
        'ase_pra_nombre': teacher.programName,
        'ase_maa_pra_codigo': teacher.programCode,
        'accion': 'Evaluar',
      });
      if (response.statusCode != 200) {
        throw SiraException('No se pudo obtener la información');
      }
      final document = parse(latin1.decode(response.data));

      if (document.querySelector('td[width="100%"]>form') == null) {
        throw SiraException('No se pudo iniciar la evaluación');
      }
      final inputs = document
          .querySelector('td[width="100%"]>form')!
          .querySelectorAll('input[type="HIDDEN"]')
          .sublist(0, 21);
      final data = <String, String>{};
      for (final input in inputs) {
        if (input.attributes['name']?.isEmpty ?? false) continue;
        data[input.attributes['name']!] = input.attributes['value']!;
      }
      final List<QuestionsSubject> questions = [];

      final subjectQuestionsTexts =
          document.querySelectorAll('.asignatura > td[size]');
      final subjectQuestionsIds =
          document.querySelectorAll('.asignatura > td[size] > input');
      for (int i = 0; i < subjectQuestionsTexts.length; i++) {
        final question = subjectQuestionsTexts[i].text;
        final questionId = subjectQuestionsIds[i].attributes['value'] ?? '';
        questions.add(QuestionsSubject(
            question: question, id: questionId, category: 'Asignatura'));
      }
      final teacherQuestionsTexts =
          document.querySelectorAll('.profesor > td[size]');
      final teacherQuestionsIds =
          document.querySelectorAll('.profesor > td[size] > input');
      for (int i = 0; i < teacherQuestionsTexts.length; i++) {
        final question = teacherQuestionsTexts[i].text;
        final questionId = teacherQuestionsIds[i].attributes['value'] ?? '';
        questions.add(QuestionsSubject(
            question: question, id: questionId, category: 'Docente'));
      }
      final studentQuestionsTexts =
          document.querySelectorAll('.estudiante > td[size]');
      final studentQuestionsIds =
          document.querySelectorAll('.estudiante > td[size] > input');
      for (int i = 0; i < studentQuestionsTexts.length; i++) {
        final question = studentQuestionsTexts[i].text;
        final questionId = studentQuestionsIds[i].attributes['value'] ?? '';
        questions.add(QuestionsSubject(
            question: question, id: questionId, category: 'Estudiante'));
      }

      return ReviewSubject(
          bodyData: data,
          questions: questions,
          teacherName: teacher.teacherName,
          subjectName: teacher.subjectName);
    } catch (e) {
      throw handleSiraError(e);
    }
  }
}
