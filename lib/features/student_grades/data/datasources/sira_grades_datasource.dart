import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:univalle_app/core/constants/sira_constants.dart';
import 'package:univalle_app/core/errors/sira_exception.dart';
import 'package:univalle_app/features/student_grades/data/models/grades_model.dart';
import 'package:univalle_app/features/student_grades/data/models/subject_model.dart';
import 'package:univalle_app/features/student_grades/domain/datasources/grades_datasource.dart';
import 'package:univalle_app/features/student_grades/domain/entities/grades.dart';

class SiraGradesDatasource implements GradesDataSource {
  final Dio _dio = Dio();

  SiraGradesDatasource() {
    _dio
      ..options.contentType = 'application/x-www-form-urlencoded'
      ..options.responseType = ResponseType.bytes;
  }

  @override
  Future<List<Grades>> getGrades(String token, String studentId) async {
    try {
      final response =
          await _dio.post(SiraConstants.baseUrl + SiraConstants.rantingPath,
              data: {
                'accion': 'Consultar Historial',
                'codigo_estudiante': studentId,
                'modulo': 'Academica',
                'x': '22',
                'y': '21'
              },
              options: Options(headers: {'Cookie': 'PHPSESSID=$token'}));
      final document = parse(latin1.decode(response.data));

      final tableRaw =
          document.querySelectorAll('table[cellspacing="1"]>tbody');
      final List<GradesModel> grades = [];
      for (final table in tableRaw) {
        final List<SubjectModel> subjects = [];
        final period = table
                .querySelector('font')
                ?.text
                .replaceFirst('PERIODO:', '')
                .trim() ??
            '';

        final tableSubjects = table.querySelectorAll('tr');
        for (final subject in tableSubjects) {
          if (subject.querySelectorAll('td').length != 11) continue;
          final subjectData = subject.querySelectorAll('td');
          final code = subjectData[0].text.trim();
          final group = subjectData[1].text.trim();
          final name = subjectData[3].text.trim();
          final credits = subjectData[7].text.trim();
          String grade = subjectData[8].text.trim();
          final isEnable = subjectData[9].text.trim().isNotEmpty;
          if (isEnable) {
            grade = subjectData[9].text.trim();
          }
          final isCanceled = subjectData[10].text.trim().isNotEmpty;
          subjects.add(SubjectModel(
              name: name,
              code: code,
              group: group,
              isCanceled: isCanceled,
              grade: double.tryParse(grade) ?? 0.0,
              isEnabled: isEnable,
              credits: int.tryParse(credits) ?? 0));
        }
        final tableSummary = table.querySelector('table>tbody');
        if (tableSummary == null) continue;
        final credits = tableSummary
                .querySelector(
                    'td [align="center"][title="Semestre: Créditos Matriculados"]')
                ?.text
                .trim() ??
            '0';
        final porcentageApproved = tableSummary
                .querySelector(
                    'td [align="center"][title="Semestre: Porcentaje de Créditos Aprobados en el Semestre"]')
                ?.text
                .trim() ??
            '0%';
        final average = tableSummary.querySelector('font')?.text.trim() ?? '0';
        final isWorthy = table.querySelector('.normalVerdeB') != null;
        grades.add(GradesModel(
            period: period,
            average: double.tryParse(average) ?? 0.0,
            credits: int.tryParse(credits) ?? 0,
            porcentageApproved: porcentageApproved,
            isWorthy: isWorthy,
            subjects: subjects));
      }
      return grades.map((e) => e.toEntity()).toList();
    } catch (e) {
      throw SiraException('Error al obtener las calificaciones');
    }
  }
}
