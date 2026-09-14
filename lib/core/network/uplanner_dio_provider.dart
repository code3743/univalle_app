import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/uplanner_constants.dart';

part 'uplanner_dio_provider.g.dart';

@Riverpod(keepAlive: true)
Dio uplannerDio(Ref ref) {
  return Dio(
    BaseOptions(
      baseUrl: UplannerConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
}
