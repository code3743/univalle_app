import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/widgets/loading_filled_button.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the label and fires onPressed when idle', (tester) async {
    var taps = 0;
    await tester.pumpApp(
      LoadingFilledButton(
        label: 'Go',
        isLoading: false,
        onPressed: () => taps++,
      ),
    );

    await tester.tap(find.text('Go'));

    expect(taps, 1);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('shows only a spinner while loading without a loadingLabel', (
    tester,
  ) async {
    await tester.pumpApp(
      const LoadingFilledButton(label: 'Go', isLoading: true, onPressed: null),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Go'), findsNothing);
  });

  testWidgets('shows the spinner next to the loadingLabel when given', (
    tester,
  ) async {
    await tester.pumpApp(
      const LoadingFilledButton(
        label: 'Go',
        loadingLabel: 'Going',
        isLoading: true,
        onPressed: null,
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Going'), findsOneWidget);
  });
}
