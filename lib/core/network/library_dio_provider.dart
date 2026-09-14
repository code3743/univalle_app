import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/library_constants.dart';

part 'library_dio_provider.g.dart';

/// The library catalog (opac.univalle.edu.co) is a separate OPAC system
/// with its own session, unrelated to sira.univalle.edu.co — so it needs
/// its own Dio instance and cookie jar rather than reusing [siraDioProvider].
@Riverpod(keepAlive: true)
CookieJar libraryCookieJar(Ref ref) => CookieJar();

@Riverpod(keepAlive: true)
Dio libraryDio(Ref ref) {
  final cookieJar = ref.watch(libraryCookieJarProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: LibraryConstants.baseUrl,
      contentType: 'application/x-www-form-urlencoded',
      responseType: ResponseType.plain,
      connectTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  dio.interceptors.add(CookieManager(cookieJar));
  return dio;
}
