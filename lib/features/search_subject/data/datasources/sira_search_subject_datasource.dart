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
              .replaceAll('QUERY', _checkQuery(query))
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

      final suggestions = rows.map((row) {
        final cells = row.querySelectorAll('td');
        final code = cells[1].text.trim();
        final name = cells[2].text.trim();
        final onClick = _getQuerySearch(
                cells[1].querySelector('a')?.attributes['onclick']) ??
            '$code -> $name';
        return SubjectSuggestion(code: code, name: name, query: onClick);
      }).toList();

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
  Future<List<SubjectResult>> searchSubjects(
      String query, String campus) async {
    // TODO: implement searchSubjects
    throw UnimplementedError();
  }
}
