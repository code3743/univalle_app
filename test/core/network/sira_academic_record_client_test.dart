import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/sira_constants.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/core/network/sira_academic_record_client.dart';

class MockDio extends Mock implements Dio {}

Response<List<int>> _response(String html, {int statusCode = 200}) => Response(
  requestOptions: RequestOptions(path: SiraConstants.academicRecordPath),
  statusCode: statusCode,
  data: latin1.encode(html),
);

void main() {
  late MockDio dio;
  late SiraAcademicRecordClient client;

  setUpAll(() => registerFallbackValue(<String, dynamic>{}));

  setUp(() {
    dio = MockDio();
    client = SiraAcademicRecordClient(dio);
  });

  test('echoes the form inputs back when generating the full report', () async {
    when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer((
      invocation,
    ) async {
      final data = invocation.namedArguments[#data];
      if (data is Map && data['accion'] == 'Generar Carpeta') {
        return _response('<html><body>report</body></html>');
      }
      return _response('<form><input name="ventana" value="carpeta"></form>');
    });

    final document = await client.fetchFullReport(
      studentCode: '123',
      unavailableMessage: 'unavailable',
    );

    expect(document.body?.text, 'report');
    final captured = verify(
      () => dio.post(any(), data: captureAny(named: 'data')),
    ).captured;
    final reportRequest = captured.last as Map;
    expect(reportRequest['ventana'], 'carpeta');
    expect(reportRequest['TipoCarpeta'], 'COMPLETA');
  });

  test('throws a ServerException with the given message on non-200', () async {
    when(() => dio.post(any(), data: any(named: 'data')))
        .thenAnswer((invocation) async {
          final data = invocation.namedArguments[#data];
          if (data is Map && data['accion'] == 'Generar Carpeta') {
            return _response('', statusCode: 500);
          }
          return _response('<form></form>');
        });

    await expectLater(
      client.fetchFullReport(studentCode: '123', unavailableMessage: 'nope'),
      throwsA(
        isA<ServerException>().having((e) => e.message, 'message', 'nope'),
      ),
    );
  });
}
