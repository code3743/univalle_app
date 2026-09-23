import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse, parseFragment;

import '../../../../core/constants/schedule_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_exception_mapper.dart';
import '../../domain/entities/schedule_subject.dart';
import '../../domain/entities/weekday.dart';
import '../../schedule_strings.dart';
import '../models/schedule_class_model.dart';

class SiraScheduleRemoteDataSource {
  final Dio _dio;
  const SiraScheduleRemoteDataSource(this._dio);

  // Matches a session's day/time/building line when a room is assigned,
  // e.g. "JUE: 14:00-17:00 , Edf. B13 (B13) -> SALA 1 -- MG -- MELENDEZ".
  // Hours may be one or two digits ("8:00" as well as "14:00"). The
  // location detail after the building code is optional and, when
  // present, captured whole in group 5 for `_locationLine` to parse.
  static final _sessionWithBuilding = RegExp(
    r'^(LUN|MAR|MI[EÉ]|JUE|VIE|SAB|DOM):\s*(\d{1,2}:\d{2})\s*-\s*(\d{1,2}:\d{2})\s*,\s*Edf\.\s*(\S+)\s*(\(.*)?$',
    caseSensitive: false,
  );

  // Matches the same line when SIRA has no room assigned yet, e.g.
  // "JUE: 8:00-12:00 ,SIN ESPACIO -- MG" — no building, and no second
  // location line follows it.
  static final _sessionWithoutBuilding = RegExp(
    r'^(LUN|MAR|MI[EÉ]|JUE|VIE|SAB|DOM):\s*(\d{1,2}:\d{2})\s*-\s*(\d{1,2}:\d{2})\s*,\s*SIN\s*ESPACIO\b',
    caseSensitive: false,
  );

  // Matches the location detail, e.g. "(B13) -> SALA 1 -- MG -- MELENDEZ" —
  // usually on the same line as `_sessionWithBuilding` right after the
  // building code, occasionally (defensively handled) on the next line.
  static final _locationLine = RegExp(
    r'^\([^)]*\)\s*->\s*(.+?)\s*--\s*(.+?)\s*--\s*(.+)$',
  );

  // The teacher cell often runs the institutional email right after the
  // name with no separator, e.g. "JOSE LUIS UNAS GOMEZjose.unas@correo...".
  static final _email = RegExp(r'[\w.+-]+@[\w-]+(?:\.[\w-]+)+');

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

    final document = parse(latin1.decode(response.data as List<int>));
    // SIRA occasionally renders the programming table twice for the same
    // query (an identical `table[width="768"]` duplicated in the response).
    // Scoping to the first one avoids parsing — and thus doubling — every
    // session in it.
    final table = document.querySelector('table[width="768"]');
    if (table == null) return const [];

    return table
        .querySelectorAll('tbody>tr')
        .expand((row) => _parseGroupRow(row, subject))
        .toList();
  }

  List<ScheduleClassModel> _parseGroupRow(
    Element row,
    ScheduleSubject subject,
  ) {
    final cells = row.querySelectorAll('td');
    // Every group row for a subject has exactly 9 columns; other row
    // shapes on the page (headers, spacers) don't and are skipped.
    if (cells.length != 9) return const [];
    if (cells[2].text.trim() != subject.group) return const [];

    final scheduleLines = _splitByBreaks(cells[4]);
    if (scheduleLines.isEmpty) return const [];

    final teacher = _parseTeacher(cells[5].text.trim());
    return _parseSessions(scheduleLines)
        .map(
          (session) => ScheduleClassModel(
            subjectCode: subject.code,
            subjectName: subject.name,
            group: subject.group,
            teacher: teacher.name,
            teacherEmail: teacher.email,
            day: session.day,
            startTime: session.startTime,
            endTime: session.endTime,
            building: session.building,
            room: session.room,
            campus: session.campus,
          ),
        )
        .toList();
  }

  // The schedule cell packs one or more sessions separated by <br> tags
  // rather than actual newlines in the source HTML, so lines must be split
  // on the markup itself — splitting the extracted text on '\n' leaves
  // every session glued into one string with no separator to find.
  List<String> _splitByBreaks(Element cell) => cell.innerHtml
      .split(RegExp(r'<br\s*/?>', caseSensitive: false))
      .map((fragment) => parseFragment(fragment).text?.trim() ?? '')
      .where((line) => line.isNotEmpty)
      .toList();

  // The schedule cell packs one or more sessions, each its own <br>-
  // separated line: "JUE: 14:00-17:00 , Edf. B13 (B13) -> SALA 1 -- MG --
  // MELENDEZ" (the middle "--" segment is an internal room-type code that
  // isn't meaningful to show the student). When no room is assigned yet,
  // it's just "JUE: 8:00-12:00 ,SIN ESPACIO -- MG" with no location detail.
  List<_ParsedSession> _parseSessions(List<String> lines) {
    final sessions = <_ParsedSession>[];
    var i = 0;
    while (i < lines.length) {
      final withBuilding = _sessionWithBuilding.firstMatch(lines[i]);
      if (withBuilding != null) {
        var room = '';
        var campus = '';
        final sameLineLocation = withBuilding.group(5);
        if (sameLineLocation != null) {
          final locationMatch = _locationLine.firstMatch(sameLineLocation);
          if (locationMatch != null) {
            room = locationMatch.group(1)!.trim();
            campus = locationMatch.group(3)!.trim();
          }
        } else if (i + 1 < lines.length) {
          final locationMatch = _locationLine.firstMatch(lines[i + 1]);
          if (locationMatch != null) {
            room = locationMatch.group(1)!.trim();
            campus = locationMatch.group(3)!.trim();
            i++;
          }
        }

        final day = Weekday.fromSiraCode(withBuilding.group(1)!);
        if (day != null) {
          sessions.add(
            _ParsedSession(
              day: day,
              startTime: _normalizeTime(withBuilding.group(2)!),
              endTime: _normalizeTime(withBuilding.group(3)!),
              building: withBuilding.group(4)!.trim(),
              room: room,
              campus: campus,
            ),
          );
        }
        i++;
        continue;
      }

      final withoutBuilding = _sessionWithoutBuilding.firstMatch(lines[i]);
      if (withoutBuilding != null) {
        final day = Weekday.fromSiraCode(withoutBuilding.group(1)!);
        if (day != null) {
          sessions.add(
            _ParsedSession(
              day: day,
              startTime: _normalizeTime(withoutBuilding.group(2)!),
              endTime: _normalizeTime(withoutBuilding.group(3)!),
              building: '',
              room: '',
              campus: '',
            ),
          );
        }
      }
      i++;
    }
    return sessions;
  }

  // SIRA renders single-digit hours without a leading zero ("8:00"); pad
  // them so lexicographic sorting of start times still matches chronological
  // order.
  String _normalizeTime(String rawTime) {
    final parts = rawTime.split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1]}';
  }

  _ParsedTeacher _parseTeacher(String rawTeacher) {
    final emailMatch = _email.firstMatch(rawTeacher);
    if (emailMatch == null) return _ParsedTeacher(name: rawTeacher);

    final email = emailMatch.group(0)!;
    final name = rawTeacher.replaceFirst(email, '').trim();
    return _ParsedTeacher(name: name, email: email);
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

class _ParsedSession {
  final Weekday day;
  final String startTime;
  final String endTime;
  final String building;
  final String room;
  final String campus;

  const _ParsedSession({
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.building,
    required this.room,
    required this.campus,
  });
}

class _ParsedTeacher {
  final String name;
  final String? email;

  const _ParsedTeacher({required this.name, this.email});
}
