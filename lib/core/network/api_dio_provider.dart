import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/api_constants.dart';

part 'api_dio_provider.g.dart';

@Riverpod(keepAlive: true)
Dio apiDio(Ref ref) {
  return Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      // Skips ngrok's browser-warning interstitial page while baseUrl points
      // at a free-tier tunnel; harmless once it points at the real backend.
      headers: const {'ngrok-skip-browser-warning': 'true'},
    ),
  );
}
