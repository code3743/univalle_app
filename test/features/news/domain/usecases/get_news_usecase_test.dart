import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/news/domain/entities/news_article.dart';
import 'package:univalle_app/features/news/domain/repositories/news_repository.dart';
import 'package:univalle_app/features/news/domain/usecases/get_news_usecase.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  late MockNewsRepository repository;
  late GetNewsUseCase useCase;

  setUp(() {
    repository = MockNewsRepository();
    useCase = GetNewsUseCase(repository);
  });

  test('forwards the call to the repository', () async {
    when(() => repository.getNews(page: 2))
        .thenAnswer((_) async => const Ok(<NewsArticle>[]));

    final result = await useCase.call(page: 2);

    expect(result.isOk, isTrue);
    verify(() => repository.getNews(page: 2)).called(1);
  });

  test('propagates a failure result unchanged', () async {
    final failure = UnknownFailure(message: 'boom');
    when(() => repository.getNews(page: 2))
        .thenAnswer((_) async => Err<List<NewsArticle>>(failure));

    final result = await useCase.call(page: 2);

    expect((result as Err<List<NewsArticle>>).failure, failure);
  });
}
