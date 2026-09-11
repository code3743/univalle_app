import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/campus.dart';
import '../../../../core/constants/sira_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_exception_mapper.dart';
import '../../profile_strings.dart';
import '../models/student_model.dart';

typedef _ContactInfo = ({
  String documentId,
  String firstName,
  String lastName,
  String email,
});

typedef _AcademicRecord = ({
  String campusCode,
  String programName,
  double average,
  int accumulatedCredits,
});

class SiraProfileRemoteDataSource {
  final Dio _dio;
  const SiraProfileRemoteDataSource(this._dio);

  Future<StudentModel> fetchStudent({required String username}) async {
    final contact = await _fetchContactInfo();
    final academic = await _fetchAcademicRecord(_studentCodeFrom(username));

    return StudentModel(
      documentId: contact.documentId,
      firstName: contact.firstName,
      lastName: contact.lastName,
      email: contact.email,
      programName: academic.programName,
      campus: CampusCodes.nameFor(academic.campusCode),
      average: academic.average,
      accumulatedCredits: academic.accumulatedCredits,
    );
  }

  String _studentCodeFrom(String username) => username.split('-').first;

  Future<_ContactInfo> _fetchContactInfo() async {
    final response = await _run(
      () => _dio.post(
        SiraConstants.studentPath,
        data: {
          'accion': 'desplegarFmInformacionDeContacto',
          'x': '31',
          'y': '24',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw const ServerException(message: ProfileStrings.studentInfoUnavailable);
    }

    final document = parse(latin1.decode(response.data as List<int>));
    String value(String selector) =>
        document.querySelector(selector)?.attributes['value']?.trim() ?? '';

    final firstName = value('input[name="per_nombre"]');
    if (firstName.isEmpty) {
      throw const AuthException(message: AppStrings.sessionExpired);
    }

    return (
      documentId: value('input[name="per_doc_ide_numero"]'),
      firstName: firstName,
      lastName: value('input[name="per_apellido"]'),
      email: value('input[name="per_email_institucional"]'),
    );
  }

  Future<_AcademicRecord> _fetchAcademicRecord(String studentCode) async {
    final formResponse = await _run(
      () => _dio.post(
        SiraConstants.academicRecordPath,
        data: {
          'accion': 'Consultar Historial',
          'codigo_estudiante': studentCode,
          'modulo': 'Academica',
          'x': '22',
          'y': '21',
        },
      ),
    );

    final formDocument = parse(latin1.decode(formResponse.data as List<int>));
    final formData = <String, String>{};
    for (final input in formDocument.querySelectorAll('form > input')) {
      final name = input.attributes['name'];
      final value = input.attributes['value'];
      if (name != null && value != null) formData[name] = value;
    }
    formData['TipoCarpeta'] = 'COMPLETA';
    formData['DetalleCarpeta'] = 'COMPLETA';
    formData['accion'] = 'Generar Carpeta';

    final recordResponse = await _run(
      () => _dio.post(SiraConstants.academicRecordPath, data: formData),
    );

    if (recordResponse.statusCode != 200) {
      throw const ServerException(message: ProfileStrings.studentInfoUnavailable);
    }

    final recordDocument = parse(latin1.decode(recordResponse.data as List<int>));
    final lines = recordDocument
            .querySelector('font')
            ?.text
            .trim()
            .split('\n')
            .map((line) => line.trim())
            .where((line) => line.isNotEmpty)
            .map((line) => line.split(':').length > 1 ? line.split(':')[1].trim() : '')
            .toList() ??
        const <String>[];

    // Third line format: "programId-campusCode-...-programName".
    final programFields = lines.length > 2 ? lines[2].split('-') : const <String>[];
    if (programFields.length < 4) {
      throw const ServerException(message: ProfileStrings.studentInfoUnavailable);
    }

    final averageText = recordDocument.querySelector('.error > font')?.text.trim();
    final creditsCells = recordDocument.querySelectorAll(
      'td[title="Acumulado: Número de Créditos Aprobados Acumulados"]',
    );
    final creditsText = creditsCells.isNotEmpty ? creditsCells.last.text.trim() : null;

    return (
      campusCode: programFields[1].trim(),
      programName: programFields[3].trim(),
      average: double.tryParse(averageText ?? '') ?? 0,
      accumulatedCredits: int.tryParse(creditsText ?? '') ?? 0,
    );
  }

  Future<T> _run<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
