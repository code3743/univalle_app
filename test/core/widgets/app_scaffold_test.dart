import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/theme/app_theme.dart';
import 'package:univalle_app/core/widgets/app_scaffold.dart';

Future<void> _pump(WidgetTester tester, AppScaffold scaffold) =>
    tester.pumpWidget(MaterialApp(theme: AppTheme.light, home: scaffold));

void main() {
  testWidgets('shows an app bar with the title and actions', (tester) async {
    await _pump(
      tester,
      const AppScaffold(
        title: 'Notas',
        actions: [Icon(Icons.search)],
        body: Text('contenido'),
      ),
    );

    expect(find.widgetWithText(AppBar, 'Notas'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.text('contenido'), findsOneWidget);
  });

  testWidgets('has no app bar without a title or a custom app bar', (
    tester,
  ) async {
    await _pump(tester, const AppScaffold(body: Text('contenido')));

    expect(find.byType(AppBar), findsNothing);
  });

  testWidgets('prefers a custom app bar over the title', (tester) async {
    await _pump(
      tester,
      AppScaffold(
        title: 'Ignorado',
        appBar: AppBar(title: const Text('Propia')),
        body: const Text('contenido'),
      ),
    );

    expect(find.text('Propia'), findsOneWidget);
    expect(find.text('Ignorado'), findsNothing);
  });

  testWidgets('scrolls its body by default and not when scrollable is false', (
    tester,
  ) async {
    await _pump(tester, const AppScaffold(body: Text('contenido')));
    expect(find.byType(SingleChildScrollView), findsOneWidget);

    await _pump(
      tester,
      const AppScaffold(scrollable: false, body: Text('contenido')),
    );
    expect(find.byType(SingleChildScrollView), findsNothing);
  });
}
