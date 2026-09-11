import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;

import '../../../../core/constants/sira_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_exception_mapper.dart';
import '../../auth_strings.dart';

class SiraAuthRemoteDataSource {
  final Dio _dio;
  const SiraAuthRemoteDataSource(this._dio);

  Future<void> login({required String username, required String password}) async {
    if (username.isEmpty || password.isEmpty) {
      throw const AuthException(message: AuthStrings.missingCredentials);
    }

    final response = await _run(
      () => _dio.post(
        '',
        data: {
          'redirect': '',
          'usu_login_aut': username,
          'usu_password_aut': password,
          'boton': 'Ingresar al Sistema',
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) => status != null && status >= 200 && status < 400,
        ),
      ),
    );

    if (response.statusCode == 200) {
      final document = parse(latin1.decode(response.data as List<int>));
      final rawMessage = document.querySelector('.resaltar')?.text.trim() ?? '';
      final message = rawMessage.replaceFirst(RegExp(r'^[A-Z]+\s*\d+\s*.*:\s'), '').trim();
      throw AuthException(
        message: message.isNotEmpty ? message : AuthStrings.invalidCredentials,
      );
    }
  }

  Future<void> logout() async {
    await _run(() => _dio.get(SiraConstants.logoutPath));
  }

  Future<void> resetPassword({required String username}) async {
    if (username.isEmpty) {
      throw const AuthException(message: AuthStrings.missingUsername);
    }

    final formResponse = await _run(
      () => _dio.get(
        SiraConstants.resetPasswordUrl,
        options: Options(responseType: ResponseType.plain),
      ),
    );
    if (formResponse.statusCode != 200) {
      throw const ServerException(message: AuthStrings.serverNotResponding);
    }

    final formDocument = parse(formResponse.data as String);
    final token = formDocument
        .querySelector('input[name="parametros[_csrf_token]"]')
        ?.attributes['value'];
    if (token == null) {
      throw const ServerException(message: AuthStrings.resetServiceUnavailable);
    }

    final resetResponse = await _run(
      () => _dio.post(
        SiraConstants.resetPasswordUrl,
        data: {
          'parametros[_csrf_token]': token,
          'parametros[usuario]': username,
        },
        options: Options(responseType: ResponseType.plain),
      ),
    );
    if (resetResponse.statusCode != 200) {
      throw const ServerException(message: AuthStrings.serverNotResponding);
    }

    final resetDocument = parse(resetResponse.data as String);
    final errorMessage = resetDocument.querySelector('.error')?.text.trim();
    if (errorMessage != null && errorMessage.isNotEmpty) {
      throw AuthException(message: errorMessage);
    }
  }

  Future<T> _run<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
