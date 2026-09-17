import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/news/data/datasources/news_remote_datasource.dart';
import 'package:univalle_app/features/news/data/models/news_article_model.dart';
import 'package:univalle_app/features/news/data/repositories/news_repository_impl.dart';
import 'package:univalle_app/features/news/domain/entities/news_article.dart';

class MockNewsRemoteDataSource extends Mock implements NewsRemoteDataSource {}

void main() {
  late MockNewsRemoteDataSource remote;
  late NewsRepositoryImpl repository;

  setUp(() {
    remote = MockNewsRemoteDataSource();
    repository = NewsRepositoryImpl(remote);
  });

  test('returns the articles mapped to entities on success', () async {
    when(() => remote.fetchNews(page: 0)).thenAnswer(
      (_) async => const [
        NewsArticleModel(
          title: 'Título',
          summary: 'Resumen',
          sourceUrl: 'https://www.univalle.edu.co/noticia',
        ),
      ],
    );

    final result = await repository.getNews(page: 0);

    expect(result, isA<Ok<List<NewsArticle>>>());
    expect((result as Ok<List<NewsArticle>>).value.single.title, 'Título');
  });

  test('maps a thrown AppException to a Failure', () async {
    when(() => remote.fetchNews(page: 0))
        .thenThrow(const ServerException(message: 'boom', statusCode: 500));

    final result = await repository.getNews(page: 0);

    expect((result as Err<List<NewsArticle>>).failure, isA<ServerFailure>());
  });
}
