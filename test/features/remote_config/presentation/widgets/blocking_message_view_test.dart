import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/remote_config/presentation/widgets/blocking_message_view.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the icon, title and message without an action', (
    tester,
  ) async {
    await tester.pumpApp(
      const BlockingMessageView(
        icon: Icons.build_circle_outlined,
        title: 'Título',
        message: 'Mensaje',
      ),
    );

    expect(find.byIcon(Icons.build_circle_outlined), findsOneWidget);
    expect(find.text('Título'), findsOneWidget);
    expect(find.text('Mensaje'), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);
  });

  testWidgets('shows the action button and calls it', (tester) async {
    var pressed = false;
    await tester.pumpApp(
      BlockingMessageView(
        icon: Icons.info,
        title: 't',
        message: 'm',
        actionLabel: 'Hacer',
        onAction: () => pressed = true,
      ),
    );

    await tester.tap(find.text('Hacer'));

    expect(pressed, isTrue);
  });
}
