import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/constants/app_strings.dart';
import 'package:univalle_app/core/widgets/app_empty_view.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the title, message and icon', (tester) async {
    await tester.pumpApp(
      const AppEmptyView(
        icon: Icons.apps_outlined,
        title: 'Nada por aquí',
        message: 'Vuelve más tarde.',
      ),
    );

    expect(find.text('Nada por aquí'), findsOneWidget);
    expect(find.text('Vuelve más tarde.'), findsOneWidget);
    expect(find.byIcon(Icons.apps_outlined), findsOneWidget);
    expect(find.text(AppStrings.retry), findsNothing);
  });

  testWidgets('shows a retry button only when onRetry is provided', (
    tester,
  ) async {
    var retried = false;
    await tester.pumpApp(
      AppEmptyView(
        icon: Icons.cloud_off_outlined,
        title: 'Sin conexión',
        onRetry: () => retried = true,
      ),
    );

    expect(find.text(AppStrings.retry), findsOneWidget);

    await tester.tap(find.text(AppStrings.retry));
    await tester.pumpAndSettle();

    expect(retried, isTrue);
  });
}
