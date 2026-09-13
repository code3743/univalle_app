import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

import '../../../../core/constants/sira_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_exception_mapper.dart';
import '../../student_grades_strings.dart';
import '../models/grades_model.dart';
import '../models/subject_model.dart';

class SiraGradesRemoteDataSource {
  final Dio _dio;
  const SiraGradesRemoteDataSource(this._dio);

  Future<List<GradesModel>> fetchGrades({required String username}) async {
    final report = await _fetchFullReport(_studentCodeFrom(username));
    final periodTables = report.querySelectorAll(
      'table[cellspacing="1"]>tbody',
    );
    return periodTables.map(_parsePeriod).whereType<GradesModel>().toList();
  }

  String _studentCodeFrom(String username) => username.split('-').first;

  GradesModel? _parsePeriod(Element table) {
    final summaryTable = table.querySelector('table>tbody');
    if (summaryTable == null) return null;

    final period =
        table.querySelector('font')?.text.replaceFirst('PERIODO:', '').trim() ??
        '';
    final creditsText =
        summaryTable
            .querySelector(
              'td [align="center"][title="Semestre: Créditos Matriculados"]',
            )
            ?.text
            .trim() ??
        '0';
    final approvedPercentage =
        summaryTable
            .querySelector(
              'td [align="center"][title="Semestre: Porcentaje de Créditos Aprobados en el Semestre"]',
            )
            ?.text
            .trim() ??
        '0%';
    final averageText = summaryTable.querySelector('font')?.text.trim() ?? '0';

    return GradesModel(
      period: period,
      average: double.tryParse(averageText) ?? 0,
      credits: int.tryParse(creditsText) ?? 0,
      approvedPercentage: approvedPercentage,
      // SIRA marks periods with an academic merit distinction ("estímulo
      // académico") by rendering the summary in this highlighted CSS class.
      hasAcademicMerit: table.querySelector('.normalVerdeB') != null,
      subjects: table
          .querySelectorAll('tr')
          .map(_parseSubject)
          .whereType<SubjectModel>()
          .toList(),
    );
  }

  SubjectModel? _parseSubject(Element row) {
    final cells = row.querySelectorAll('td');
    // Each subject row has exactly 11 columns; other row shapes are headers/summaries.
    if (cells.length != 11) return null;

    final name = cells[3].text.trim();
    if (name == 'ASIGNATURA') return null;

    // Column 9 (habilitación) overrides column 8 (definitiva) when a subject
    // was passed through a supplementary exam instead of the regular term.
    final finalGrade = cells[8].text.trim();
    final habilitacionGrade = cells[9].text.trim();

    return SubjectModel(
      code: cells[0].text.trim(),
      group: cells[1].text.trim(),
      campusId: cells[2].text.trim(),
      name: name,
      credits: int.tryParse(cells[7].text.trim()) ?? 0,
      grade: habilitacionGrade.isNotEmpty ? habilitacionGrade : finalGrade,
      isCanceled: cells[10].text.trim().contains('CANCELACIÓN'),
    );
  }

  Future<Document> _fetchFullReport(String studentCode) async {
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

    final reportResponse = await _run(
      () => _dio.post(SiraConstants.academicRecordPath, data: formData),
    );

    if (reportResponse.statusCode != 200) {
      throw const ServerException(
        message: StudentGradesStrings.gradesUnavailable,
      );
    }

    return parse(latin1.decode(reportResponse.data as List<int>));
  }

  Future<T> _run<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
