import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/schedule_constants.dart';

part 'schedule_dio_provider.g.dart';

@Riverpod(keepAlive: true)
Dio scheduleDio(Ref ref) {
  return Dio(
    BaseOptions(
      baseUrl: ScheduleConstants.baseUrl,
      contentType: 'application/x-www-form-urlencoded',
      responseType: ResponseType.bytes,
      connectTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
}
