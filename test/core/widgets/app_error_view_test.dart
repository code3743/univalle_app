import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/constants/app_strings.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/widgets/app_error_view.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('shows a Failure\'s user message with a retry button', (
    tester,
  ) async {
    var retried = false;
    await tester.pumpApp(
      AppErrorView(
        error: NetworkFailure(message: 'timeout'),
        onRetry: () => retried = true,
      ),
    );

    expect(find.text(AppStrings.networkError), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);

    await tester.tap(find.text(AppStrings.retry));
    expect(retried, isTrue);
  });

  testWidgets('shows the generic message for a non-Failure error', (
    tester,
  ) async {
    await tester.pumpApp(AppErrorView(error: StateError('boom')));

    expect(find.text(AppStrings.genericError), findsOneWidget);
    expect(find.text(AppStrings.retry), findsNothing);
  });

  testWidgets(
    'shows a non-retryable business failure as information without retry',
    (tester) async {
      await tester.pumpApp(
        AppErrorView(
          error: BusinessFailure(message: 'Sin encuesta', retryable: false),
          onRetry: () {},
        ),
      );

      expect(find.byIcon(Icons.info_outline), findsOneWidget);
      expect(find.text(AppStrings.retry), findsNothing);
    },
  );
}
