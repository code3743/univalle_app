import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

import '../../../../core/constants/sira_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_exception_mapper.dart';
import '../../resolution_strings.dart';
import '../models/curriculum_subject_model.dart';

class SiraResolutionRemoteDataSource {
  final Dio _dio;
  const SiraResolutionRemoteDataSource(this._dio);

  Future<List<CurriculumSubjectModel>> fetchCurriculum({
    required String username,
  }) async {
    final response = await _run(
      () => _dio.post(
        SiraConstants.resolutionPath,
        data: {
          'accion': 'ListadoPrerrequisitos',
          'est_codigo': _studentCodeFrom(username),
          'pra_codigo': _programCodeFrom(username),
          'x': '16',
          'y': '17',
        },
      ),
    );

    final document = parse(latin1.decode(response.data as List<int>));
    final Iterable<Element> rows =
        document
            .querySelector('.tituloIndex>table>tbody')
            ?.querySelectorAll('tr')
            .skip(2) ??
        const <Element>[];

    // SIRA repeats a subject's row once per prerequisite, each repetition
    // carrying only one prerequisite code in the last column; merge those
    // rows back into a single subject with the full prerequisite list.
    final byCode = <String, CurriculumSubjectModel>{};
    for (final row in rows) {
      final cells = row.querySelectorAll('td');
      if (cells.length < 7) continue;

      final code = cells[2].text.trim();
      final prerequisiteCode = cells[6].text.trim();
      final existing = byCode[code];
      if (existing != null) {
        if (prerequisiteCode.isNotEmpty &&
            !existing.prerequisiteCodes.contains(prerequisiteCode)) {
          existing.prerequisiteCodes.add(prerequisiteCode);
        }
        continue;
      }

      byCode[code] = CurriculumSubjectModel(
        semester: int.tryParse(cells[1].text.trim()) ?? 0,
        code: code,
        name: cells[3].text.trim(),
        subjectType: cells[4].text.trim(),
        credits: int.tryParse(cells[5].text.trim()) ?? 0,
        prerequisiteCodes: prerequisiteCode.isEmpty ? [] : [prerequisiteCode],
      );
    }

    if (byCode.isEmpty) {
      throw const ServerException(
        message: ResolutionStrings.curriculumUnavailable,
      );
    }

    return byCode.values.toList();
  }

  String _studentCodeFrom(String username) => '20${username.split('-').first}';
  String _programCodeFrom(String username) => username.split('-').last;

  Future<T> _run<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
