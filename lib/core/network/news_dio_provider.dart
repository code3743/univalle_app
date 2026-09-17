import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/news_constants.dart';

part 'news_dio_provider.g.dart';

// The news agency page is public (no login), so unlike the other scraped
// sources this needs neither a cookie jar nor a persistent session.
@Riverpod(keepAlive: true)
Dio newsDio(Ref ref) {
  return Dio(
    BaseOptions(
      baseUrl: NewsConstants.baseUrl,
      responseType: ResponseType.plain,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
}
