import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/extensions/snackbar_extension.dart';

void main() {
  testWidgets('shows a SnackBar with the given message', (tester) async {
    late BuildContext capturedContext;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    capturedContext.showSnack('Hola mundo');
    await tester.pump();

    expect(find.text('Hola mundo'), findsOneWidget);
  });

  testWidgets(
    'hides the currently visible SnackBar before showing the new one',
    (tester) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      capturedContext.showSnack('Primero');
      await tester.pump();
      capturedContext.showSnack('Segundo');
      await tester.pump();

      expect(find.text('Primero'), findsNothing);
      expect(find.text('Segundo'), findsOneWidget);
    },
  );
}
