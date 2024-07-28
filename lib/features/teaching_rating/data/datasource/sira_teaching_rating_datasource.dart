import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:univalle_app/core/errors/sira_exception.dart';
import 'package:univalle_app/core/errors/handle_sira_errors.dart';
import 'package:univalle_app/core/constants/course_evaluation.dart';
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

  @override
  Future<String> authenticateSession(String user, String password) async {
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

      final cookies =
          await _cookieJar.loadForRequest(Uri.parse(CourseEvaluation.baseUrl));
      return cookies.first.value;
    } catch (e) {
      throw handleSiraError(e);
    }
  }

  @override
  Future<List<TeachingRating>> getTeachingQualifications(
      String sessionId) async {
    try {
      final response = await _dio.get(
          CourseEvaluation.baseUrl + CourseEvaluation.homePath,
          options: Options(headers: {'Cookie': 'PHPSESSID=$sessionId'}));
      if (response.statusCode != 200) {
        throw SiraException('No se pudo obtener la información');
      }
      final document = parse(latin1.decode(response.data));
      final forms = document.querySelectorAll('form');
      final teachers = <TeachingRating>[];
      for (final form in forms) {
        final Map<String, dynamic> data = {};

        final teacherName = form.querySelector('span')?.text ?? '';
        final isQualified =
            form.querySelector('span')?.attributes['title']?.trim() ==
                'El Docente ya ha sido evaluado';
        data['teacherName'] = teacherName;
        data['isQualified'] = isQualified;
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
  Future<void> sendTeachingQualification(
      TeachingRating teacher, String sessionId) {
    // TODO: implement sendTeachingQualification
    throw UnimplementedError();
  }
}
