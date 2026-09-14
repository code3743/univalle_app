import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/widgets/app_loading_indicator.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('renders a CircularProgressIndicator at the given size', (
    tester,
  ) async {
    await tester.pumpApp(const AppLoadingIndicator(size: 48));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    final sizedBox = tester.widget<SizedBox>(
      find.ancestor(
        of: find.byType(CircularProgressIndicator),
        matching: find.byType(SizedBox),
      ),
    );
    expect(sizedBox.width, 48);
    expect(sizedBox.height, 48);
  });
}
