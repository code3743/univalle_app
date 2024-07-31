import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:univalle_app/config/constants/sira_constants.dart';
import 'package:univalle_app/core/errors/handle_sira_errors.dart';
import 'package:univalle_app/core/errors/sira_exception.dart';
import 'package:univalle_app/features/student_tabulate/domain/datasource/tabulate_datasource.dart';
import 'package:univalle_app/features/student_tabulate/domain/entities/tabulate.dart';

class SiraTabulateDatasource implements TabulateDataSource {
  final Dio _dio = Dio();

  SiraTabulateDatasource() {
    _dio
      ..options.contentType = 'application/x-www-form-urlencoded'
      ..options.responseType = ResponseType.bytes;
  }

  @override
  Future<Tabulate> getTabulate(
      String studentId, String programId, String token) async {
    try {
      final response =
          await _dio.post(SiraConstants.baseUrl + SiraConstants.tabulatedPath,
              data: {
                'accion': 'Generar Tabulado',
                'est_codigo': studentId,
                'pra_codigo': programId,
                'x': '30',
                'y': '37'
              },
              options: Options(
                headers: {
                  'Cookie': 'PHPSESSID=$token',
                },
              ));
      final content = latin1
          .decode(response.data)
          .replaceAll('href="/sra/', 'href="https://sira.univalle.edu.co/sra/')
          .replaceAll('src="/sra/', 'src="https://sira.univalle.edu.co/sra/');
      final document = parse(content.replaceAll('<head>', '').replaceAll(
          '</head>',
          '<head><style>body, html {height: 100%; margin: 0;display: flex;justify-content: center;align-items: center;} .box{width: 90%;transform: scale(1.1);}</style> </head>'));
      if (document.querySelector('img[name="logoUV"]') == null) {
        throw SiraException('Tabulado no disponible');
      }
      document.querySelector('noscript')?.remove();
      document.querySelector('a')?.remove();
      document.querySelector('table')?.remove();
      document.querySelector('table')?.attributes['class'] = 'box';
      document.querySelector('table')?.attributes.remove('width');

      return Tabulate(content: document.outerHtml);
    } catch (e) {
      throw handleSiraError(e);
    }
  }
}
