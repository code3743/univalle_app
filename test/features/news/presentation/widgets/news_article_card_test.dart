import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/news/news_strings.dart';
import 'package:univalle_app/features/news/presentation/widgets/news_article_card.dart';

import '../../../../helpers/fake_url_launcher.dart';
import '../../../../helpers/pump_app.dart';
import '../news_fixtures.dart';

void main() {
  testWidgets('shows the title and summary, without category or image', (
    tester,
  ) async {
    await tester.pumpApp(NewsArticleCard(article: article(1)));

    expect(find.text('Noticia 1'), findsOneWidget);
    expect(find.text('Resumen 1'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('shows the category when there is one', (tester) async {
    await tester.pumpApp(
      NewsArticleCard(article: article(1, category: 'Cultura')),
    );

    expect(find.text('Cultura'), findsOneWidget);
  });

  testWidgets('shows a placeholder when the thumbnail fails to load', (
    tester,
  ) async {
    await tester.pumpApp(
      NewsArticleCard(
        article: article(1, imageUrl: 'https://img.example/1.png'),
      ),
    );

    final image = tester.widget<Image>(find.byType(Image));
    final fallback = image.errorBuilder!(
      tester.element(find.byType(Image)),
      Exception('x'),
      null,
    );

    await tester.pumpWidget(MaterialApp(home: fallback));
    expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
  });

  testWidgets('opens the article externally when tapped', (tester) async {
    final launcher = FakeUrlLauncher.install();
    await tester.pumpApp(NewsArticleCard(article: article(7)));

    await tester.tap(find.byType(NewsArticleCard));
    await tester.pump();

    expect(launcher.launched, ['https://news.example/7']);
  });

  testWidgets('tells the user when the article cannot be opened', (
    tester,
  ) async {
    FakeUrlLauncher.install(canOpen: false);
    await tester.pumpApp(NewsArticleCard(article: article(7)));

    await tester.tap(find.byType(NewsArticleCard));
    await tester.pump();

    expect(find.text(NewsStrings.cannotOpenArticleLink), findsOneWidget);
  });
}
