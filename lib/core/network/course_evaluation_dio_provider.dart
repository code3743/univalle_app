import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/course_evaluation_constants.dart';

part 'course_evaluation_dio_provider.g.dart';

/// The teaching-evaluation site lives on its own domain
/// (evaluacioncursos.univalle.edu.co) with its own login and session,
/// separate from the main sira.univalle.edu.co one — so it needs its own
/// Dio instance and cookie jar rather than reusing [siraDioProvider].
@Riverpod(keepAlive: true)
CookieJar courseEvaluationCookieJar(Ref ref) => CookieJar();

@Riverpod(keepAlive: true)
Dio courseEvaluationDio(Ref ref) {
  final cookieJar = ref.watch(courseEvaluationCookieJarProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: CourseEvaluationConstants.baseUrl,
      contentType: 'application/x-www-form-urlencoded',
      responseType: ResponseType.bytes,
      connectTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  dio.interceptors.add(CookieManager(cookieJar));
  return dio;
}
