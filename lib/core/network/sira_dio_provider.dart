import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/sira_constants.dart';

part 'sira_dio_provider.g.dart';

@Riverpod(keepAlive: true)
CookieJar siraCookieJar(Ref ref) => CookieJar();

@Riverpod(keepAlive: true)
Dio siraDio(Ref ref) {
  final cookieJar = ref.watch(siraCookieJarProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: SiraConstants.baseUrl,
      contentType: 'application/x-www-form-urlencoded',
      responseType: ResponseType.bytes,
    ),
  );
  dio.interceptors.add(CookieManager(cookieJar));
  return dio;
}
