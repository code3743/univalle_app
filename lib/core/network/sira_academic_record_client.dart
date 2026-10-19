import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/sira_constants.dart';
import '../error/exceptions.dart';
import 'dio_exception_mapper.dart';
import 'sira_dio_provider.dart';

part 'sira_academic_record_client.g.dart';

class SiraAcademicRecordClient {
  final Dio _dio;
  const SiraAcademicRecordClient(this._dio);

  /// SIRA only generates the report after a first POST returns a form whose
  /// hidden inputs must be echoed back verbatim in a second one.
  Future<Document> fetchFullReport({
    required String studentCode,
    required String unavailableMessage,
  }) async {
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
      throw ServerException(message: unavailableMessage);
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

@Riverpod(keepAlive: true)
SiraAcademicRecordClient siraAcademicRecordClient(Ref ref) {
  return SiraAcademicRecordClient(ref.watch(siraDioProvider));
}
