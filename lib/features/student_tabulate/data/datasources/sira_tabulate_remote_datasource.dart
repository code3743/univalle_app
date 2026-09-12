import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

import '../../../../core/constants/sira_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_exception_mapper.dart';
import '../../student_tabulate_strings.dart';

class SiraTabulateRemoteDataSource {
  final Dio _dio;
  const SiraTabulateRemoteDataSource(this._dio);

  Future<String> fetchTabulate({required String username}) async {
    final response = await _run(
      () => _dio.post(
        SiraConstants.tabulatedPath,
        data: {
          'accion': 'Generar Tabulado',
          'est_codigo': _studentCodeFrom(username),
          'pra_codigo': _programCodeFrom(username),
          'x': '30',
          'y': '37',
        },
      ),
    );

    final document = parse(latin1.decode(response.data as List<int>));
    if (document.querySelector('img[name="logoUV"]') == null) {
      throw const ServerException(
        message: StudentTabulateStrings.tabuladoUnavailable,
      );
    }

    _relocateHeadElements(document);
    _removeDeadInteractiveElements(document);
    _removeCruft(document);
    _scaleToFitViewport(document);

    return document.outerHtml;
  }

  String _studentCodeFrom(String username) => username.split('-').first;
  String _programCodeFrom(String username) => username.split('-').last;

  // SIRA's response is malformed (duplicated <body>, a stray <head> opened
  // after content already started), so the parser leaves <meta>/<link>/
  // <title> sitting inside <body> instead of <head>. Move them back so the
  // document is well-formed and those tags don't render as stray text.
  void _relocateHeadElements(Document document) {
    final head = document.head!;
    for (final tag in ['meta', 'link', 'title']) {
      for (final element in document.querySelectorAll(tag).toList()) {
        element.remove();
        head.append(element);
      }
    }

    head
            .querySelector('meta[http-equiv="Content-Type"]')
            ?.attributes['content'] =
        'text/html; charset=utf-8';

    head.nodes.insert(
      0,
      Element.tag('base')..attributes['href'] = SiraConstants.baseUrl,
    );
  }

  // Print buttons and prerequisite-list forms don't work standalone (no
  // window.print(), no page navigation), so they'd just be dead taps.
  void _removeDeadInteractiveElements(Document document) {
    for (final tag in ['script', 'noscript', 'a', 'form']) {
      for (final element in document.querySelectorAll(tag).toList()) {
        element.remove();
      }
    }
  }

  // Strip markup that carries no visual meaning once this is a read-only,
  // in-app view: generator comments, and the legacy body attributes (right-
  // click blocking, zeroed margins already superseded by our own CSS reset).
  void _removeCruft(Document document) {
    _removeComments(document);
    document.body?.attributes.removeWhere(
      (name, _) => const {
        'oncontextmenu',
        'leftmargin',
        'topmargin',
        'marginwidth',
        'marginheight',
        'rightmargin',
        'bgcolor',
        'text',
      }.contains(name),
    );
  }

  void _removeComments(Node node) {
    node.nodes.removeWhere((child) => child.nodeType == Node.COMMENT_NODE);
    for (final child in node.nodes) {
      _removeComments(child);
    }
  }

  // The document is a fixed-width print layout (the frame table is
  // 765px), and it's a formal university record: reflowing its tables would
  // change what it actually says fits where, which we don't want to touch.
  // Instead we wrap the whole body and scale it down as one image would be
  // scaled: `zoom` (unlike `transform: scale`) affects layout, so the page's
  // own scrollHeight comes out already shrunk to the device width.
  void _scaleToFitViewport(Document document) {
    final designWidth = _frameWidthOf(document);

    document.head!.append(
      Element.tag('meta')
        ..attributes['name'] = 'viewport'
        ..attributes['content'] = 'width=device-width, initial-scale=1',
    );
    document.head!.append(
      Element.tag('style')
        ..text =
            '''
          html, body { margin: 0 !important; overflow-x: hidden; }
          #mobileWrapper { zoom: calc(100vw / ${designWidth}px); }
        ''',
    );

    final body = document.body!;
    final wrapper = Element.tag('div')..attributes['id'] = 'mobileWrapper';
    for (final child in List<Node>.from(body.nodes)) {
      child.remove();
      wrapper.append(child);
    }
    body.append(wrapper);
  }

  int _frameWidthOf(Document document) {
    final width = int.tryParse(
      document.querySelector('#tableFramework')?.attributes['width'] ?? '',
    );
    return width ?? 765;
  }

  Future<T> _run<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
