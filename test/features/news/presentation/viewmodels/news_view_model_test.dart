import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/news/domain/entities/news_article.dart';
import 'package:univalle_app/features/news/domain/repositories/news_repository.dart';
import 'package:univalle_app/features/news/presentation/providers/news_providers.dart';
import 'package:univalle_app/features/news/presentation/viewmodels/news_view_model.dart';

import '../../../../helpers/container.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

NewsArticle _article(String title) =>
    NewsArticle(title: title, summary: 's', sourceUrl: 'https://x/$title');

void main() {
  late MockNewsRepository repository;

  setUp(() {
    repository = MockNewsRepository();
  });

  List<Override> overridesWith(NewsRepository repo) => [
    newsRepositoryProvider.overrideWithValue(repo),
  ];

  test(
    'build fetches page 0 and reports hasMore when it returns results',
    () async {
      when(() => repository.getNews(page: 0))
          .thenAnswer((_) async => Ok([_article('a'), _article('b')]));
      final container = createContainer(overrides: overridesWith(repository));

      final feed = await container.read(newsViewModelProvider.future);

      expect(feed.articles, hasLength(2));
      expect(feed.hasMore, isTrue);
    },
  );

  test('build reports hasMore as false when the first page is empty', () async {
    when(() => repository.getNews(page: 0))
        .thenAnswer((_) async => const Ok([]));
    final container = createContainer(overrides: overridesWith(repository));

    final feed = await container.read(newsViewModelProvider.future);

    expect(feed.articles, isEmpty);
    expect(feed.hasMore, isFalse);
  });

  test('build throws the failure when the repository call fails', () async {
    final failure = NetworkFailure(message: 'down');
    when(() => repository.getNews(page: 0))
        .thenAnswer((_) async => Err(failure));
    final container = createContainer(overrides: overridesWith(repository));

    await expectLater(
      container.read(newsViewModelProvider.future),
      throwsA(same(failure)),
    );
  });

  test('loadMore appends the next page and advances the page cursor', () async {
    when(() => repository.getNews(page: 0))
        .thenAnswer((_) async => Ok([_article('a')]));
    when(() => repository.getNews(page: 1))
        .thenAnswer((_) async => Ok([_article('b')]));
    final container = createContainer(overrides: overridesWith(repository));
    await container.read(newsViewModelProvider.future);

    await container.read(newsViewModelProvider.notifier).loadMore();

    final feed = container.read(newsViewModelProvider).value!;
    expect(feed.articles.map((a) => a.title), ['a', 'b']);
    verify(() => repository.getNews(page: 1)).called(1);
  });

  test('loadMore is a no-op once the feed has no more pages', () async {
    when(() => repository.getNews(page: 0))
        .thenAnswer((_) async => const Ok([]));
    final container = createContainer(overrides: overridesWith(repository));
    await container.read(newsViewModelProvider.future);

    await container.read(newsViewModelProvider.notifier).loadMore();

    verifyNever(() => repository.getNews(page: 1));
  });

  test('loadMore throws the failure when the repository call fails', () async {
    when(() => repository.getNews(page: 0))
        .thenAnswer((_) async => Ok([_article('a')]));
    when(() => repository.getNews(page: 1))
        .thenAnswer((_) async => Err(NetworkFailure(message: 'down')));
    final container = createContainer(overrides: overridesWith(repository));
    await container.read(newsViewModelProvider.future);

    await expectLater(
      container.read(newsViewModelProvider.notifier).loadMore(),
      throwsA(isA<NetworkFailure>()),
    );
  });
}
