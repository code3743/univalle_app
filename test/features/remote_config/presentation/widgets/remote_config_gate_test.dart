import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:univalle_app/core/device/app_platform_provider.dart';
import 'package:univalle_app/core/domain/entities/app_config.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/remote_config/presentation/providers/remote_config_providers.dart';
import 'package:univalle_app/features/remote_config/presentation/views/maintenance_view.dart';
import 'package:univalle_app/features/remote_config/presentation/views/update_required_view.dart';
import 'package:univalle_app/features/remote_config/presentation/widgets/remote_config_gate.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/pump_app.dart';
import '../remote_config_fixtures.dart';

void main() {
  late MockRemoteConfigRepository repository;

  setUp(() {
    repository = MockRemoteConfigRepository();
    PackageInfo.setMockInitialValues(
      appName: 'Univalle',
      packageName: 'co.edu.univalle',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  Future<void> pumpGate(
    WidgetTester tester,
    Future<Result<AppConfig>> config,
  ) async {
    when(
      () => repository.getConfig(
        platform: any(named: 'platform'),
        version: any(named: 'version'),
      ),
    ).thenAnswer((_) => config);
    await tester.pumpApp(
      const RemoteConfigGate(child: Text('app')),
      overrides: [
        remoteConfigRepositoryProvider.overrideWithValue(repository),
        appPlatformProvider.overrideWithValue('android'),
      ],
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders the app while the config is still loading', (
    tester,
  ) async {
    final completer = Completer<Result<AppConfig>>();
    when(
      () => repository.getConfig(
        platform: any(named: 'platform'),
        version: any(named: 'version'),
      ),
    ).thenAnswer((_) => completer.future);
    await tester.pumpApp(
      const RemoteConfigGate(child: Text('app')),
      overrides: [
        remoteConfigRepositoryProvider.overrideWithValue(repository),
        appPlatformProvider.overrideWithValue('android'),
      ],
    );
    await tester.pump();

    expect(find.text('app'), findsOneWidget);
    completer.complete(Ok(fakeAppConfig()));
    await tester.pumpAndSettle();
  });

  testWidgets('fails open: renders the app when the config fetch fails', (
    tester,
  ) async {
    await pumpGate(tester, Future.value(Err(NetworkFailure(message: 'down'))));

    expect(find.text('app'), findsOneWidget);
  });

  testWidgets('renders the app for a healthy config', (tester) async {
    await pumpGate(tester, Future.value(Ok(fakeAppConfig())));

    expect(find.text('app'), findsOneWidget);
  });

  testWidgets('blocks the app during maintenance', (tester) async {
    await pumpGate(
      tester,
      Future.value(
        Ok(
          fakeAppConfig(
            maintenance: const MaintenanceStatus(
              enabled: true,
              title: 'Mantenimiento',
              message: 'Volvemos pronto',
            ),
          ),
        ),
      ),
    );

    expect(find.byType(MaintenanceView), findsOneWidget);
    expect(find.text('app'), findsNothing);
  });

  testWidgets('blocks the app when the platform is disabled', (tester) async {
    await pumpGate(
      tester,
      Future.value(Ok(fakeAppConfig(platformEnabled: false))),
    );

    expect(find.byType(MaintenanceView), findsOneWidget);
  });

  testWidgets('blocks the app when an update is required', (tester) async {
    await pumpGate(
      tester,
      Future.value(
        Ok(
          fakeAppConfig(
            update: const UpdateStatus(
              latestVersion: '2.0.0',
              updateAvailable: true,
              updateRequired: true,
              storeUrl: 'https://store',
              message: '',
            ),
          ),
        ),
      ),
    );

    expect(find.byType(UpdateRequiredView), findsOneWidget);
    expect(find.text('app'), findsNothing);
  });
}
