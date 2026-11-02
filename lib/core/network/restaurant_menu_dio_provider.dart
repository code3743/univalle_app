import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/restaurant_constants.dart';
import 'univalle_trusted_http_client.dart';

part 'restaurant_menu_dio_provider.g.dart';

/// The weekly menu is published on the public Vicebienestar site, a
/// different host from the ticket portal, so it gets its own session-less
/// Dio instead of [restaurantDioProvider].
@Riverpod(keepAlive: true)
Dio restaurantMenuDio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: RestaurantConstants.menuBaseUrl,
      responseType: ResponseType.plain,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  dio.httpClientAdapter = IOHttpClientAdapter(
    createHttpClient: createUnivalleTrustedHttpClient,
  );
  return dio;
}
