import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:univalle_app/core/router/app_routes.dart';

import 'pump_app.dart';

void main() {
  testWidgets('pumpRoutedApp stubs every other route', (tester) async {
    late BuildContext context;
    await tester.pumpRoutedApp(
      Builder(
        builder: (c) {
          context = c;
          return const Text('under test');
        },
      ),
    );
    expect(find.text('under test'), findsOneWidget);

    context.go(AppRoutes.profile);
    await tester.pumpAndSettle();

    expect(find.text('route:${AppRoutes.profile}'), findsOneWidget);
  });
}
