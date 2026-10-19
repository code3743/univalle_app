import 'package:html/dom.dart';

import '../../../../core/network/parsers/equivalences_table_parser.dart';
import '../../../../core/network/sira_academic_record_client.dart';
import '../../student_grades_strings.dart';
import '../models/academic_history_model.dart';
import '../models/equivalence_model.dart';
import '../models/grades_model.dart';
import '../models/subject_model.dart';

class SiraGradesRemoteDataSource {
  final SiraAcademicRecordClient _client;
  const SiraGradesRemoteDataSource(this._client);

  Future<AcademicHistoryModel> fetchGrades({required String username}) async {
    final report = await _client.fetchFullReport(
      studentCode: _studentCodeFrom(username),
      unavailableMessage: StudentGradesStrings.gradesUnavailable,
    );
    final periodTables = report.querySelectorAll(
      'table[cellspacing="1"]>tbody',
    );
    return AcademicHistoryModel(
      periods: periodTables.map(_parsePeriod).whereType<GradesModel>().toList(),
      equivalences: parseEquivalences(report)
          .map(
            (row) => EquivalenceModel(
              code: row.code,
              name: row.name,
              grade: row.grade,
              typology: row.typology,
              component: row.component,
              credits: row.credits,
            ),
          )
          .toList(),
    );
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
}
