import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

import '../../../../core/constants/sira_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_exception_mapper.dart';
import '../../student_tabulate_strings.dart';

class SiraTabulateRemoteDataSource {
  static const _reportWidth = 765;

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
    await _inlineResources(document);

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
    // The report is a fixed 765px print layout. Without this, Android lays
    // it out in a ~980px viewport and leaves an empty strip on the right.
    head.append(
      Element.tag('meta')
        ..attributes['name'] = 'viewport'
        ..attributes['content'] = 'width=$_reportWidth',
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

  // The WebView does its own TLS validation and can't use the app's trusted
  // DigiCert chain, so SIRA's subresources (served without their
  // intermediate certificate) fail to load there. Download them through
  // [_dio], which does trust it, and embed them in the document instead.
  // Anything that can't be fetched keeps its absolute URL as a fallback.
  Future<void> _inlineResources(Document document) async {
    final base = Uri.parse(SiraConstants.baseUrl);
    final cache = <String, Future<Response<List<int>>?>>{};

    Future<Response<List<int>>?> fetch(String url) =>
        cache.putIfAbsent(url, () => _tryGet(url));

    await Future.wait([
      for (final image in document.querySelectorAll('img[src]'))
        _inlineImage(image, base, fetch),
      for (final sheet in document.querySelectorAll('link[href]'))
        _inlineStylesheet(sheet, base, fetch),
    ]);
  }

  Future<void> _inlineImage(
    Element image,
    Uri base,
    Future<Response<List<int>>?> Function(String url) fetch,
  ) async {
    final url = base.resolve(image.attributes['src']!).toString();
    image.attributes['src'] = url;
    final response = await fetch(url);
    final bytes = response?.data;
    if (bytes == null || bytes.isEmpty) return;
    final mime = response!.headers.value(Headers.contentTypeHeader);
    image.attributes['src'] =
        'data:${mime ?? _imageMimeFor(url)};base64,${base64Encode(bytes)}';
  }

  Future<void> _inlineStylesheet(
    Element link,
    Uri base,
    Future<Response<List<int>>?> Function(String url) fetch,
  ) async {
    final url = base.resolve(link.attributes['href']!).toString();
    link.attributes['href'] = url;
    final bytes = (await fetch(url))?.data;
    if (bytes == null || bytes.isEmpty) return;
    final style = Element.tag('style')..text = latin1.decode(bytes);
    link.replaceWith(style);
  }

  Future<Response<List<int>>?> _tryGet(String url) async {
    try {
      return await _dio.get<List<int>>(url);
    } on DioException {
      return null;
    }
  }

  String _imageMimeFor(String url) {
    final path = Uri.parse(url).path.toLowerCase();
    if (path.endsWith('.png')) return 'image/png';
    if (path.endsWith('.jpg') || path.endsWith('.jpeg')) return 'image/jpeg';
    return 'image/gif';
  }

  Future<T> _run<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
