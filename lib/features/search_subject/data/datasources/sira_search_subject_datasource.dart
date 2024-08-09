import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:univalle_app/core/errors/sira_exception.dart';
import 'package:univalle_app/core/errors/handle_sira_errors.dart';
import 'package:univalle_app/config/constants/sira_constants.dart';
import 'package:univalle_app/features/search_subject/domain/entities/subject_result.dart';
import 'package:univalle_app/features/search_subject/domain/entities/subject_suggestion.dart';
import 'package:univalle_app/features/search_subject/domain/datasources/search_subject_datasource.dart';

class SiraSearchSubjectDatasource implements SearchSubjectDataSource {
  final _dio = Dio();
  SiraSearchSubjectDatasource() {
    _dio
      ..options.contentType = 'application/x-www-form-urlencoded'
      ..options.responseType = ResponseType.bytes;
  }

  @override
  Future<List<SubjectSuggestion>> getSuggestions(
      String query, int page, String campus) async {
    try {
      final int currentPage = page * 15;

      final response = await _dio.get(SiraConstants.baseUrl +
          SiraConstants.searchSuggestionsPath
              .replaceAll('QUERY', _checkQuery(query).trim())
              .replaceAll('CAMPUS', campus)
              .replaceAll('PAGE', currentPage.toString()));

      if (response.statusCode != 200) {
        throw SiraException('El servicio no está disponible temporalmente');
      }

      final document = parse(latin1.decode(response.data));
      if (document.querySelector('.error') != null) {
        return [];
      }

      final rows = document
              .querySelector('td[bgColor="#FFFFFF"]')
              ?.querySelectorAll('tr[bgColor]') ??
          [];

      final suggestionCodes = <String>[];
      final suggestions = <SubjectSuggestion>[];

      for (final suggestion in rows) {
        final cells = suggestion.querySelectorAll('td');
        final code = cells[1].text.trim();
        if (suggestionCodes.contains(code)) continue;
        suggestionCodes.add(code);
        final name = cells[2].text.trim();
        final onClick = _getQuerySearch(
                cells[1].querySelector('a')?.attributes['onclick']) ??
            '$code -> $name';
        suggestions
            .add(SubjectSuggestion(code: code, name: name, query: onClick));
      }

      return suggestions;
    } catch (e) {
      throw handleSiraError(e);
    }
  }

  String _checkQuery(String query) {
    if (RegExp(r'^\d+[A-Z]?$').hasMatch(query)) return query;
    return '%${query.toUpperCase()}%';
  }

  String? _getQuerySearch(String? data) {
    if (data == null) return null;
    final regExp = RegExp(r"'([^']*)','([^']*)','([^']*)','([^']*)'");
    final match = regExp.firstMatch(data);
    return match?.group(3);
  }

  @override
  Future<SearchResult> searchSubjects(
      SubjectSuggestion suggestion, String campus) async {
    try {
      final response = await _dio.post(
        SiraConstants.baseUrl + SiraConstants.searchSubjectPath,
        data: SiraConstants.bodySearchSubject
            .replaceAll('CAMPUS', campus)
            .replaceAll('CODE', suggestion.code),
      );
      if (response.statusCode != 200) {
        throw SiraException('El servicio no está disponible temporalmente');
      }

      final document = parse(latin1.decode(response.data));
      final rows = document.querySelectorAll('table[width="768"]>tbody>tr');

      if (rows.isEmpty) {
        return SearchResult(
            code: suggestion.code,
            name: suggestion.name,
            credits: 0,
            results: []);
      }

      final credits = int.tryParse(
              rows[0].querySelector('font[size="2"]>b')?.text ?? '0') ??
          0;
      final RegExp regExp =
          RegExp(r"^(.+)\s([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})$");
      final List<SubjectResult> results = [];
      for (int i = 3; i < rows.length; i += 3) {
        final teacherData =
            rows[i].querySelector('td[title="Docente Responsable"]')?.text ??
                '';
        final match = regExp.firstMatch(teacherData);
        final teacherName = match?.group(1) ?? '';
        final teacherEmail = match?.group(2) ?? '';

        final schedule = rows[i]
                .querySelector('td[title="Horario de la Asignatura"]')
                ?.text ??
            '';

        final cells = rows[i + 1].querySelectorAll('td');
        final group = cells[2].text.trim();
        final capacity = int.tryParse(cells[3].text.trim()) ?? 0;
        final program = cells[6].text.trim();
        final isGeneric = cells[7].text.trim().isNotEmpty;
        final isRepeater = cells[8].text.trim().isNotEmpty;
        results.add(
          SubjectResult(
            group: group,
            teacher: teacherName,
            teacherEmail: teacherEmail,
            program: program,
            isGeneric: isGeneric,
            isRepeater: isRepeater,
            schedule: schedule,
            capacity: capacity,
          ),
        );
      }
      return SearchResult(
        code: suggestion.code,
        name: suggestion.name,
        credits: credits,
        results: results,
      );
    } catch (e) {
      throw handleSiraError(e);
    }
  }
}
