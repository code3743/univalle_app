import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/domain/entities/app_config.dart';
import 'package:univalle_app/features/remote_config/presentation/views/maintenance_view.dart';
import 'package:univalle_app/features/remote_config/remote_config_strings.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the server-provided title and message', (tester) async {
    await tester.pumpApp(
      const MaintenanceView(
        maintenance: MaintenanceStatus(
          enabled: true,
          title: 'Mejorando',
          message: 'Volvemos a las 6',
        ),
      ),
    );

    expect(find.text('Mejorando'), findsOneWidget);
    expect(find.text('Volvemos a las 6'), findsOneWidget);
  });

  testWidgets('falls back to default copy when the server sends none', (
    tester,
  ) async {
    await tester.pumpApp(
      const MaintenanceView(
        maintenance: MaintenanceStatus(enabled: true, title: '', message: ''),
      ),
    );

    expect(
      find.text(RemoteConfigStrings.maintenanceTitleFallback),
      findsOneWidget,
    );
    expect(
      find.text(RemoteConfigStrings.maintenanceMessageFallback),
      findsOneWidget,
    );
  });
}
