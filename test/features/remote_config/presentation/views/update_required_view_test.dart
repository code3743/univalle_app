import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/domain/entities/app_config.dart';
import 'package:univalle_app/features/remote_config/presentation/views/update_required_view.dart';
import 'package:univalle_app/features/remote_config/remote_config_strings.dart';

import '../../../../helpers/fake_url_launcher.dart';
import '../../../../helpers/pump_app.dart';

UpdateStatus _update({
  String message = '',
  String storeUrl = 'https://store.example/app',
}) => UpdateStatus(
  latestVersion: '2.0.0',
  updateAvailable: true,
  updateRequired: true,
  storeUrl: storeUrl,
  message: message,
);

void main() {
  testWidgets('shows the server message and opens the store', (tester) async {
    final launcher = FakeUrlLauncher.install();
    await tester.pumpApp(
      UpdateRequiredView(update: _update(message: 'Actualiza ya')),
    );

    expect(find.text('Actualiza ya'), findsOneWidget);

    await tester.tap(find.text(RemoteConfigStrings.updateButton));
    await tester.pump();

    expect(launcher.launched, ['https://store.example/app']);
  });

  testWidgets('falls back to the default message', (tester) async {
    await tester.pumpApp(UpdateRequiredView(update: _update()));

    expect(
      find.text(RemoteConfigStrings.updateRequiredMessageFallback),
      findsOneWidget,
    );
  });

  testWidgets('tells the user when the store cannot be opened', (tester) async {
    FakeUrlLauncher.install(canOpen: false);
    await tester.pumpApp(UpdateRequiredView(update: _update()));

    await tester.tap(find.text(RemoteConfigStrings.updateButton));
    await tester.pump();

    expect(find.text(RemoteConfigStrings.cannotOpenStoreLink), findsOneWidget);
  });
}
