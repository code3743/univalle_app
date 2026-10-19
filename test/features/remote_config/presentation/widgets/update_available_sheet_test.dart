import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/domain/entities/app_config.dart';
import 'package:univalle_app/features/remote_config/presentation/widgets/update_available_sheet.dart';
import 'package:univalle_app/features/remote_config/remote_config_strings.dart';

import '../../../../helpers/fake_url_launcher.dart';
import '../../../../helpers/pump_app.dart';

UpdateStatus _update({String message = ''}) => UpdateStatus(
  latestVersion: '2.0.0',
  updateAvailable: true,
  updateRequired: false,
  storeUrl: 'https://store.example/app',
  message: message,
);

void main() {
  testWidgets('shows the server message and opens the store', (tester) async {
    final launcher = FakeUrlLauncher.install();
    await tester.pumpApp(
      UpdateAvailableSheet(update: _update(message: 'Mejoras')),
    );

    expect(find.text('Mejoras'), findsOneWidget);

    await tester.tap(find.text(RemoteConfigStrings.updateButton));
    await tester.pump();

    expect(launcher.launched, ['https://store.example/app']);
  });

  testWidgets('falls back to the default message', (tester) async {
    await tester.pumpApp(UpdateAvailableSheet(update: _update()));

    expect(
      find.text(RemoteConfigStrings.updateAvailableMessageFallback),
      findsOneWidget,
    );
  });

  testWidgets('tells the user when the store cannot be opened', (tester) async {
    FakeUrlLauncher.install(canOpen: false);
    await tester.pumpApp(UpdateAvailableSheet(update: _update()));

    await tester.tap(find.text(RemoteConfigStrings.updateButton));
    await tester.pump();

    expect(find.text(RemoteConfigStrings.cannotOpenStoreLink), findsOneWidget);
  });

  testWidgets('"later" closes the sheet', (tester) async {
    await tester.pumpApp(
      Builder(
        builder: (context) => TextButton(
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            builder: (_) => UpdateAvailableSheet(update: _update()),
          ),
          child: const Text('open'),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text(RemoteConfigStrings.updateAvailableLater));
    await tester.pumpAndSettle();

    expect(find.byType(UpdateAvailableSheet), findsNothing);
  });
}
