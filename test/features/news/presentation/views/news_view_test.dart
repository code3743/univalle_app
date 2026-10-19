import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/app_strings.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/news/domain/entities/news_article.dart';
import 'package:univalle_app/features/news/news_strings.dart';
import 'package:univalle_app/features/news/presentation/providers/news_providers.dart';
import 'package:univalle_app/features/news/presentation/views/news_view.dart';
import 'package:univalle_app/features/news/presentation/widgets/news_article_card.dart';

import '../../../../helpers/pump_app.dart';
import '../news_fixtures.dart';

// A non-empty feed always renders a looping shimmer row for "load more", so
// pumpAndSettle would never return.
Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  late MockNewsRepository repository;

  setUp(() {
    repository = MockNewsRepository();
  });

  Future<void> pumpView(WidgetTester tester) async {
    await tester.pumpApp(
      const NewsView(),
      overrides: [newsRepositoryProvider.overrideWithValue(repository)],
    );
  }

  void stubPage(int page, List<NewsArticle> articles) {
    when(() => repository.getNews(page: page))
        .thenAnswer((_) async => Ok(articles));
  }

  testWidgets('shows a skeleton while loading', (tester) async {
    final completer = Completer<Result<List<NewsArticle>>>();
    when(() => repository.getNews(page: 0)).thenAnswer((_) => completer.future);

    await pumpView(tester);
    await tester.pump();

    expect(find.byType(NewsArticleCard), findsNothing);
    completer.complete(const Ok([]));
    await settle(tester);
  });

  testWidgets('lists the articles', (tester) async {
    stubPage(0, [article(1), article(2)]);
    stubPage(1, []);

    await pumpView(tester);
    await settle(tester);

    expect(find.text(NewsStrings.title), findsOneWidget);
    expect(find.byType(NewsArticleCard), findsNWidgets(2));
  });

  testWidgets('shows the empty message', (tester) async {
    stubPage(0, []);

    await pumpView(tester);
    await settle(tester);

    expect(find.text(NewsStrings.emptyMessage), findsOneWidget);
  });

  testWidgets('shows the failure and retries', (tester) async {
    when(() => repository.getNews(page: 0))
        .thenAnswer((_) async => Err(NetworkFailure(message: 'down')));
    await pumpView(tester);
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.networkError), findsOneWidget);

    stubPage(0, [article(1)]);
    stubPage(1, []);
    await tester.tap(find.text(AppStrings.retry));
    await settle(tester);

    expect(find.byType(NewsArticleCard), findsOneWidget);
  });

  testWidgets('loads the next page when scrolled near the end', (tester) async {
    stubPage(0, [for (var i = 1; i <= 10; i++) article(i)]);
    stubPage(1, [article(11)]);
    stubPage(2, []);

    await pumpView(tester);
    await tester.pump();
    await tester.pump();
    await tester.drag(
      find.byType(NewsArticleCard).first,
      const Offset(0, -3000),
    );
    await tester.pump();
    await tester.pump();

    verify(() => repository.getNews(page: 1)).called(1);
  });

  testWidgets('shows a snackbar when loading more fails', (tester) async {
    stubPage(0, [for (var i = 1; i <= 10; i++) article(i)]);
    when(() => repository.getNews(page: 1))
        .thenAnswer((_) async => Err(NetworkFailure(message: 'down')));

    await pumpView(tester);
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.drag(
      find.byType(NewsArticleCard).first,
      const Offset(0, -3000),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text(AppStrings.networkError), findsOneWidget);
  });

  testWidgets('pull to refresh reloads the feed', (tester) async {
    stubPage(0, [article(1)]);
    stubPage(1, []);

    await pumpView(tester);
    await settle(tester);
    await tester.fling(
      find.byType(NewsArticleCard).first,
      const Offset(0, 400),
      1000,
    );
    await settle(tester);

    verify(() => repository.getNews(page: 0)).called(2);
  });

  testWidgets('pull to refresh survives a failed reload', (tester) async {
    stubPage(0, [article(1)]);
    stubPage(1, []);

    await pumpView(tester);
    await settle(tester);
    when(() => repository.getNews(page: 0))
        .thenAnswer((_) async => Err(NetworkFailure(message: 'down')));
    await tester.fling(
      find.byType(NewsArticleCard).first,
      const Offset(0, 400),
      1000,
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.networkError), findsOneWidget);
  });
}
