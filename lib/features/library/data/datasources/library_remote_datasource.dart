import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

import '../../../../core/constants/library_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_exception_mapper.dart';
import '../../library_strings.dart';
import '../models/library_account_model.dart';
import '../models/library_loan_model.dart';
import '../models/library_loan_record_model.dart';

class LibraryRemoteDataSource {
  final Dio _dio;
  final CookieJar _cookieJar;
  const LibraryRemoteDataSource(this._dio, this._cookieJar);

  Future<LibraryAccountModel> fetchAccount({required String username}) async {
    try {
      // The OPAC login uses only the student code (the part of "code-program"
      // before the dash) as its patron identifier — no password.
      await _authenticate(username.split('-').first);

      final response = await _run(
        () => _dio.get(
          LibraryConstants.accountPath,
          options: Options(headers: {'referer': LibraryConstants.baseUrl}),
        ),
      );
      final document = parse(response.data as String);
      return _parseAccount(document);
    } catch (_) {
      await _cookieJar.deleteAll();
      rethrow;
    }
  }

  Future<String> renewLoan({required String barcode}) async {
    final response = await _run(
      () => _dio.get(
        '${LibraryConstants.renewPath}${Uri.encodeQueryComponent(barcode)}',
        options: Options(headers: {'referer': LibraryConstants.baseUrl}),
      ),
    );
    return _parseRenewal(response.data as String);
  }

  // The endpoint answers with an HTML fragment: "...fue renovado hasta
  // 4 Noviembre 2026" followed by an inline <script> (which must not leak
  // into the text), or a "could not be renewed" sentence with the reason.
  String _parseRenewal(String body) {
    final document = parse(body);
    document.querySelectorAll('script').forEach((script) => script.remove());
    final text = (document.body?.text ?? '').trim();
    if (text.isEmpty) {
      throw const ServerException(message: LibraryStrings.renewUnavailable);
    }
    final match = RegExp(
      r'no pudo ser renovado[^:]*:\s*(.*)',
      caseSensitive: false,
      dotAll: true,
    ).firstMatch(text);
    if (match != null) {
      final reason = match.group(1)!.trim();
      throw BusinessException(
        message: reason.isEmpty ? LibraryStrings.renewUnavailable : reason,
        retryable: false,
      );
    }
    return _normalizeRenewedDate(text);
  }

  // Rewrites "4 Noviembre 2026" as "04-Nov-2026", the format the loans table
  // uses, so the renewed row doesn't change style. Unknown shapes pass through.
  String _normalizeRenewedDate(String text) {
    final match = RegExp(
      r'renovado hasta\s+(\d{1,2})\s+(\p{L}+)\s+(\d{4})',
      caseSensitive: false,
      unicode: true,
    ).firstMatch(text);
    if (match == null) return text;
    final month =
        LibraryConstants.monthAbbreviations[match.group(2)!.toLowerCase()];
    if (month == null) return text;
    final day = match.group(1)!.padLeft(2, '0');
    return '$day-$month-${match.group(3)}';
  }

  Future<void> _authenticate(String code) async {
    await _cookieJar.deleteAll();

    final homeResponse = await _run(() => _dio.get('/'));
    final homeDocument = parse(homeResponse.data as String);

    final sessionId = _extractSessionId(homeDocument);
    if (sessionId == null) {
      throw const ServerException(message: LibraryStrings.noSessionId);
    }

    final baseUri = Uri.parse(LibraryConstants.baseUrl);
    await _cookieJar.saveFromResponse(baseUri, [
      Cookie('cgi-olib_UsesCookies', 'Notified%3A%209%2F7%2F2025'),
      Cookie('cgi-olib_SessionID', sessionId),
      Cookie('cgi-olib_Language', 'undefined'),
      Cookie('cgi-olib_lastSearchType', 'kws2'),
      Cookie('SessionID', sessionId),
    ]);

    final loginResponse = await _run(
      () => _dio.post(
        '',
        data: {
          'action': 'authenticate',
          'authentication': _buildAuthentication(sessionId, code),
        },
        options: Options(
          followRedirects: false,
          headers: {'referer': LibraryConstants.baseUrl},
          validateStatus: (status) =>
              status != null && status >= 200 && status < 400,
        ),
      ),
    );

    final loginDocument = parse(loginResponse.data as String);
    final loginError =
        loginDocument.querySelector('.loginForm')?.text.trim() ?? '';
    if (loginError.isNotEmpty) {
      throw const AuthException(message: LibraryStrings.invalidCredentials);
    }
  }

  String? _extractSessionId(Document document) {
    for (final script in document.querySelectorAll('script')) {
      final match = RegExp(r'SessionID\s*=\s*(\d+)').firstMatch(script.text);
      if (match != null) return match.group(1);
    }
    return null;
  }

  // Mirrors the OPAC login challenge: a hash of "sessionId:CODE" plus the
  // last 8 characters of a hash of "CODE" alone, joined with the full hash
  // again — an undocumented scheme reverse-engineered from the site's JS.
  String _buildAuthentication(String sessionId, String code) {
    final upperCode = code.toUpperCase();
    final authHash = _md5Hex('$sessionId:$upperCode');
    final codeHash = _md5Hex(upperCode);
    final finalAuth = codeHash.substring(codeHash.length - 8) + authHash;
    return '$finalAuth-$authHash';
  }

  String _md5Hex(String input) =>
      md5.convert(utf8.encode(input)).toString().toUpperCase();

  LibraryAccountModel _parseAccount(Document document) {
    final fineElement = document.querySelector('#user_CURBAL_text');
    if (fineElement == null) {
      throw const ServerException(message: LibraryStrings.accountUnavailable);
    }

    return LibraryAccountModel(
      currentFine: fineElement.text.trim(),
      currentLoans: _parseLoans(document),
      history: _parseRecords(document, LibraryConstants.historyTableSelector),
    );
  }

  // Columns: barcode, title, location, due date, fine, renew icon.
  List<LibraryLoanModel> _parseLoans(Document document) {
    final rows =
        document
            .querySelector(LibraryConstants.currentLoansTableSelector)
            ?.querySelectorAll('tr') ??
        <Element>[];
    final loans = <LibraryLoanModel>[];
    for (var i = 1; i < rows.length; i++) {
      final cells = rows[i].querySelectorAll('td');
      if (cells.length < 5) continue;
      loans.add(
        LibraryLoanModel(
          code: cells[0].text.trim(),
          title: cells[1].text.trim(),
          location: cells[2].text.trim(),
          dueDate: cells[3].text.trim(),
          fine: cells[4].text.trim(),
        ),
      );
    }
    return loans;
  }

  // History rows: barcode, title, location, transaction type, date.
  List<LibraryLoanRecordModel> _parseRecords(
    Document document,
    String tableSelector,
  ) {
    final tableBody = document.querySelector(tableSelector);
    final rows = tableBody?.querySelectorAll('tr') ?? <Element>[];
    final records = <LibraryLoanRecordModel>[];
    for (var i = 1; i < rows.length; i++) {
      final cells = rows[i].querySelectorAll('td');
      if (cells.length < 5) continue;
      records.add(
        LibraryLoanRecordModel(
          code: cells[0].text.trim(),
          title: cells[1].text.trim(),
          location: cells[2].text.trim(),
          date: cells[4].text.trim(),
        ),
      );
    }
    return records;
  }

  Future<T> _run<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
