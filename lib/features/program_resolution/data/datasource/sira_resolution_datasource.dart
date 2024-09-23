import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:univalle_app/config/constants/sira_constants.dart';
import 'package:univalle_app/core/errors/handle_sira_errors.dart';
import 'package:univalle_app/features/program_resolution/data/models/subject_cycle_model.dart';
import 'package:univalle_app/features/program_resolution/domain/datasource/resolution_datasource.dart';
import 'package:univalle_app/features/program_resolution/domain/entities/subject_cycle.dart';

class SiraResolutionDatasource implements ResolutionDataSource {
  final Dio _dio = Dio();

  SiraResolutionDatasource() {
    _dio
      ..options.contentType = 'application/x-www-form-urlencoded'
      ..options.responseType = ResponseType.bytes;
  }

  @override
  Future<List<SubjectCycle>> getResolution(
      String token, String studentId, String programId) async {
    try {
      final response =
          await _dio.post(SiraConstants.baseUrl + SiraConstants.resolutionPath,
              data: {
                'accion': 'ListadoPrerrequisitos',
                'est_codigo': studentId,
                'pra_codigo': programId,
                'x': '16',
                'y': '17'
              },
              options: Options(headers: {
                'Cookie': 'PHPSESSID=$token',
              }));
      final document = parse(latin1.decode(response.data));

      final Map<String, List<Map<String, dynamic>>> data = {};
      final tableRaw = document
          .querySelector('.tituloIndex>table>tbody')!
          .querySelectorAll('tr')
          .sublist(2);
      for (final tr in tableRaw) {
        final row = tr.querySelectorAll('td');
        final cycle = int.parse(row[1].text.trim()).toString();
        final code = row[2].text.trim();
        final name = row[3].text.trim();
        final subjectType = row[4].text.trim();
        final credits = row[5].text.trim();
        final prereqCode = row[6].text.trim();

        if (!data.containsKey(cycle)) {
          data[cycle] = [];
        }

        if (data[cycle]!.any((element) => element['code'] == code)) {
          if (prereqCode.isNotEmpty) {
            data[cycle]!
                .firstWhere(
                    (element) => element['code'] == code)['prerequisites']
                .add(prereqCode);
          }
        } else {
          data[cycle]!.add({
            'code': code,
            'name': name,
            'subjectType': subjectType,
            'credits': credits,
            'prerequisites': prereqCode.isEmpty ? [] : [prereqCode],
          });
        }
      }
      final result = ResultCycleModel.fromJson(data).cycles;
      return result.map((e) => e.toEntity()).toList();
    } catch (e) {
      throw handleSiraError(e);
    }
  }
}
