import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/constants/app_strings.dart';
import 'package:univalle_app/core/widgets/shimmer/app_shimmer.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('renders its child', (tester) async {
    await tester.pumpApp(const AppShimmer(child: Text('content')));

    expect(find.text('content'), findsOneWidget);
  });

  testWidgets('exposes a loading semantics label', (tester) async {
    await tester.pumpApp(const AppShimmer(child: SizedBox()));

    expect(find.bySemanticsLabel(AppStrings.loading), findsOneWidget);
  });

  testWidgets('settles immediately when animations are disabled', (
    tester,
  ) async {
    await tester.pumpApp(
      const MediaQuery(
        data: MediaQueryData(disableAnimations: true),
        child: AppShimmer(child: SizedBox()),
      ),
    );

    await tester.pumpAndSettle();
  });
}
