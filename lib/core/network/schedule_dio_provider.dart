import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/schedule_constants.dart';
import 'univalle_trusted_http_client.dart';

part 'schedule_dio_provider.g.dart';

@Riverpod(keepAlive: true)
Dio scheduleDio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ScheduleConstants.baseUrl,
      contentType: 'application/x-www-form-urlencoded',
      responseType: ResponseType.bytes,
      connectTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  dio.httpClientAdapter = IOHttpClientAdapter(
    createHttpClient: createUnivalleTrustedHttpClient,
  );
  return dio;
}
