import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;

import '../../../../core/constants/schedule_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_exception_mapper.dart';
import '../../domain/entities/schedule_subject.dart';
import '../../schedule_strings.dart';
import '../models/schedule_class_model.dart';
import '../parsers/sira_schedule_parser.dart';

class SiraScheduleRemoteDataSource {
  final Dio _dio;
  const SiraScheduleRemoteDataSource(this._dio);

  // SIRA occasionally times out or errors on an individual subject request
  // under load. Each subject is fetched and retried independently (see
  // `_fetchSubjectSchedule`), so a retry here never re-fetches a subject
  // that already succeeded.
  static const _maxAttemptsPerSubject = 3;
  static const _retryDelay = Duration(milliseconds: 500);

  Future<List<ScheduleClassModel>> fetchSchedule({
    required List<ScheduleSubject> subjects,
  }) async {
    final results = await Future.wait(subjects.map(_fetchSubjectSchedule));
    return results.expand((sessions) => sessions).toList();
  }

  Future<List<ScheduleClassModel>> _fetchSubjectSchedule(
    ScheduleSubject subject,
  ) async {
    for (var attempt = 1; ; attempt++) {
      try {
        return await _fetchSubjectScheduleOnce(subject);
      } on AppException catch (e) {
        final isTransient = e is NetworkException || e is ServerException;
        if (!isTransient || attempt >= _maxAttemptsPerSubject) rethrow;
        await Future.delayed(_retryDelay * attempt);
      }
    }
  }

  Future<List<ScheduleClassModel>> _fetchSubjectScheduleOnce(
    ScheduleSubject subject,
  ) async {
    final response = await _run(
      () => _dio.post(ScheduleConstants.path, data: _bodyFor(subject)),
    );
    if (response.statusCode != 200) {
      throw const ServerException(message: ScheduleStrings.scheduleUnavailable);
    }

    return SiraScheduleParser.parse(
      parse(latin1.decode(response.data as List<int>)),
      subject,
    );
  }

  String _bodyFor(ScheduleSubject subject) =>
      'sed_codigo=${Uri.encodeQueryComponent(subject.campusId)}'
      '&agp_asi_codigo=${Uri.encodeQueryComponent(subject.code)}'
      '&wincomboagp_asi_codigo='
      // SIRA compares this raw, latin1-encoded ("ó"=%F3, "é"=%E9) rather
      // than UTF-8, so it can't be built by url-encoding a Dart string.
      '&accion=Consultar+Programaci%F3n+Acad%E9mica'
      '&fac_codigo=1'
      '&una_codigo=102'
      '&pra_codigo='
      '&tipo_consulta=desplegarFormularioConsultarProgramacion';

  Future<T> _run<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
