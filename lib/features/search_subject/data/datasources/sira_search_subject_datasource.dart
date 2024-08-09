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

  Future<String> _getSession(String campus) async {
    final response = await _dio
        .post(SiraConstants.baseUrl + SiraConstants.searchSubjectPath, data: {
      'facultad': '1',
      'sed_codigo': campus,
      'accion': 'desplegarFormularioConsultarProgramacion',
      'boton': 'Consultar+Programación'
    });
    final cookies = response.headers.map['set-cookie'];
    if (cookies == null) {
      throw SiraException('No se pudo obtener la sesión');
    }
    final document = parse(latin1.decode(response.data));
    print(document.querySelectorAll('form input').length);
    return cookies
        .where((element) => element.contains('PHPSESSID'))
        .first
        .split(';')
        .first;
  }

  @override
  Future<List<SubjectResult>> searchSubjects(
      SubjectSuggestion suggestion, String campus) async {
    try {
      final token = await _getSession(campus);
      print(token);
      final response = await _dio.post(
          SiraConstants.baseUrl + SiraConstants.searchSubjectPath,
          data:
              'sed_codigo=06&agp_asi_codigo=990001M&wincomboagp_asi_codigo=&accion=Consultar+Programaci%F3n+Acad%E9mica&fac_codigo=1&una_codigo=102&tipo_consulta=desplegarFormularioConsultarProgramacion&fac_codigo=1&pra_codigo=&tipo_consulta=desplegarFormularioConsultarProgramacion',
          options: Options(headers: {'Cookie': token}));
      print(campus);
      if (response.statusCode != 200) {
        throw SiraException('El servicio no está disponible temporalmente');
      }

      final document = parse(latin1.decode(response.data));
      print(document.outerHtml);
      print(document.querySelectorAll('tables').length);

      return [];
    } catch (e) {
      throw handleSiraError(e);
    }
  }
}
