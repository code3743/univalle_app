import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import 'package:univalle_app/core/constants/sira_constants.dart';
import 'package:univalle_app/core/errors/sira_exception.dart';
import 'package:univalle_app/features/auth/data/models/student_model.dart';
import 'package:univalle_app/features/auth/domain/datasources/auth_datasource.dart';
import 'package:univalle_app/features/auth/domain/entities/student.dart';

class SiraAuthDatasource implements AuthDatasource {
  final _dio = Dio();
  final _cookieJar = CookieJar();
  late Student _student;
  SiraAuthDatasource() {
    _dio
      ..interceptors.add(CookieManager(_cookieJar))
      ..options.contentType = 'application/x-www-form-urlencoded'
      ..options.responseType = ResponseType.bytes;
  }

  Future<Student> _getStudent(String code, String password) async {
    try {
      final studentResponse = await _dio
          .post(SiraConstants.baseUrl + SiraConstants.studentPath, data: {
        'accion': 'desplegarFmInformacionDeContacto',
        'x': '31',
        'y': '24'
      });
      final rantingResponse = await _dio
          .post(SiraConstants.baseUrl + SiraConstants.rantingPath, data: {
        'accion': 'Consultar Historial',
        'codigo_estudiante': code,
        'modulo': 'Academica',
        'x': '22',
        'y': '21'
      });
      if (studentResponse.statusCode != 200 ||
          rantingResponse.statusCode != 200) {
        throw SiraException('No se pudo obtener la información del estudiante');
      }
      final rantingDocument = parse(latin1.decode(rantingResponse.data));
      final studentDocument = parse(latin1.decode(studentResponse.data));
      final dataRanting = rantingDocument
              .querySelector('font')
              ?.text
              .trim()
              .split('\n')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .map((e) => e.split(':')[1].trim())
              .toList() ??
          [];
      final studentData = {
        'token':
            (await _cookieJar.loadForRequest(Uri.parse(SiraConstants.baseUrl)))
                .first
                .value,
        'fristName': studentDocument
                .querySelector('input[name="per_nombre"]')
                ?.attributes['value'] ??
            '',
        'lastName': studentDocument
                .querySelector('input[name="per_apellido"]')
                ?.attributes['value'] ??
            '',
        'email': studentDocument
                .querySelector('input[name="per_email_institucional"]')
                ?.attributes['value'] ??
            '',
        'documentId': studentDocument
                .querySelector('input[name="per_doc_ide_numero"]')
                ?.attributes['value'] ??
            '',
        'password': password,
        'average': double.tryParse(
                rantingDocument.querySelector('.error > font')?.text.trim() ??
                    '') ??
            0,
        'studentId': dataRanting[0].split(' -- ')[0],
        'programId': dataRanting[2].split('-')[0],
        'campus': dataRanting[2].split('-')[1],
        'programName': dataRanting[2].split('-')[3],
        'accumulatedCredits': int.tryParse(rantingDocument
                .querySelectorAll(
                    'td[title="Acumulado: Número de Créditos Aprobados Acumulados"]')
                .last
                .text
                .trim()) ??
            0,
        'studentFines': 0,
      };
      return StudentModel.fromJson(studentData).toEntity();
    } on DioException catch (dioError) {
      switch (dioError.type) {
        case DioExceptionType.badCertificate:
          throw SiraException('Certificado no válido');
        case DioExceptionType.connectionTimeout:
          throw SiraException('Tiempo de conexión agotado');
        case DioExceptionType.badResponse:
          throw SiraException('Respuesta inesperada');
        case DioExceptionType.cancel:
          throw SiraException('Petición cancelada');
        case DioExceptionType.connectionError:
          throw SiraException('Error de conexión');
        case DioExceptionType.sendTimeout:
          throw SiraException('Tiempo de envío agotado');
        case DioExceptionType.receiveTimeout:
          throw SiraException('Tiempo de recepción agotado');
        default:
          throw SiraException('Error desconocido');
      }
    } on SiraException {
      rethrow;
    } catch (e) {
      throw SiraException('Error desconocido: $e');
    }
  }

  @override
  Future<void> login(String user, String password) async {
    try {
      if (user.isEmpty || password.isEmpty) {
        throw SiraException('Usuario y contraseña son requeridos');
      }

      if (!RegExp(r'^\d+-\d+').hasMatch(user)) {
        throw SiraException('Usuario no válido');
      }

      final response = await _dio.post(SiraConstants.baseUrl,
          data: {
            'redirect': '',
            'usu_login_aut': user,
            'usu_password_aut': password,
            'boton': 'Ingresar al Sistema'
          },
          options: Options(
              followRedirects: false,
              validateStatus: (status) =>
                  status != null && status >= 200 && status < 400));

      if (response.statusCode == 200) {
        final checkLogin = parse(latin1.decode(response.data));
        final errorMessage =
            checkLogin.querySelector('.resaltar')?.text.trim() ?? '';
        final error = errorMessage
            .replaceFirst(RegExp(r'^[A-Z]+\s*\d+\s*.*:\s'), '')
            .trim();
        throw SiraException(error);
      }
      _student = await _getStudent(user.split('-')[0], password);
    } on DioException catch (dioError) {
      switch (dioError.type) {
        case DioExceptionType.badCertificate:
          throw SiraException('Certificado no válido');
        case DioExceptionType.connectionTimeout:
          throw SiraException('Tiempo de conexión agotado');
        case DioExceptionType.badResponse:
          throw SiraException('Respuesta inesperada');
        case DioExceptionType.cancel:
          throw SiraException('Petición cancelada');
        case DioExceptionType.connectionError:
          throw SiraException('Error de conexión');
        case DioExceptionType.sendTimeout:
          throw SiraException('Tiempo de envío agotado');
        case DioExceptionType.receiveTimeout:
          throw SiraException('Tiempo de recepción agotado');
        default:
          throw SiraException('Error desconocido');
      }
    } on SiraException {
      rethrow;
    } catch (e) {
      throw SiraException('Error desconocido $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.get(SiraConstants.baseUrl + SiraConstants.logoutPath);
      await _cookieJar.deleteAll();
    } on DioException catch (dioError) {
      switch (dioError.type) {
        case DioExceptionType.badCertificate:
          throw SiraException('Certificado no válido');
        case DioExceptionType.connectionTimeout:
          throw SiraException('Tiempo de conexión agotado');
        case DioExceptionType.badResponse:
          throw SiraException('Respuesta inesperada');
        case DioExceptionType.cancel:
          throw SiraException('Petición cancelada');
        case DioExceptionType.connectionError:
          throw SiraException('Error de conexión');
        case DioExceptionType.sendTimeout:
          throw SiraException('Tiempo de envío agotado');
        case DioExceptionType.receiveTimeout:
          throw SiraException('Tiempo de recepción agotado');
        default:
          throw SiraException('Error desconocido');
      }
    } catch (e) {
      throw SiraException('Error desconocido');
    }
  }

  @override
  Future<Student> getStudent() {
    return Future.value(_student);
  }
}
