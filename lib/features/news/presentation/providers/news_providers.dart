import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/news_dio_provider.dart';
import '../../data/datasources/news_remote_datasource.dart';
import '../../data/repositories/news_repository_impl.dart';
import '../../domain/repositories/news_repository.dart';
import '../../domain/usecases/get_news_usecase.dart';

part 'news_providers.g.dart';

@Riverpod(keepAlive: true)
NewsRemoteDataSource newsRemoteDataSource(Ref ref) {
  return NewsRemoteDataSource(ref.watch(newsDioProvider));
}

@Riverpod(keepAlive: true)
NewsRepository newsRepository(Ref ref) {
  return NewsRepositoryImpl(ref.watch(newsRemoteDataSourceProvider));
}

@Riverpod(keepAlive: true)
GetNewsUseCase getNewsUseCase(Ref ref) {
  return GetNewsUseCase(ref.watch(newsRepositoryProvider));
}
