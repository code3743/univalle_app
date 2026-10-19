import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/domain/entities/app_config.dart';
import 'package:univalle_app/core/domain/entities/welcome_banner.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/remote_config/presentation/providers/remote_config_providers.dart';
import 'package:univalle_app/features/remote_config/presentation/widgets/home_overlays.dart';
import 'package:univalle_app/features/remote_config/presentation/widgets/update_available_sheet.dart';
import 'package:univalle_app/features/remote_config/presentation/widgets/welcome_banner_dialog.dart';
import 'package:univalle_app/features/remote_config/remote_config_strings.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/pump_app.dart';
import '../remote_config_fixtures.dart';

const _updateAvailable = UpdateStatus(
  latestVersion: '2.0.0',
  updateAvailable: true,
  updateRequired: false,
  storeUrl: 'https://store',
  message: '',
);

const _banner = WelcomeBanner(
  enabled: true,
  title: 'Bienvenido',
  description: 'Novedades',
);

void main() {
  late MockRemoteConfigRepository repository;

  setUp(() {
    repository = MockRemoteConfigRepository();
    when(() => repository.getDismissedUpdate())
        .thenAnswer((_) async => const Ok(null));
    when(() => repository.getSeenWelcome())
        .thenAnswer((_) async => const Ok(null));
    when(() => repository.dismissUpdate(any()))
        .thenAnswer((_) async => const Ok(null));
    when(() => repository.markWelcomeSeen(any()))
        .thenAnswer((_) async => const Ok(null));
  });

  Future<void> pumpOverlays(WidgetTester tester, AppConfig? config) async {
    await tester.pumpApp(
      HomeOverlays(config: config),
      overrides: [remoteConfigRepositoryProvider.overrideWithValue(repository)],
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows nothing until a config arrives', (tester) async {
    await pumpOverlays(tester, null);

    expect(find.byType(UpdateAvailableSheet), findsNothing);
    expect(find.byType(WelcomeBannerDialog), findsNothing);
  });

  testWidgets('shows the update sheet first and records the dismissal', (
    tester,
  ) async {
    await pumpOverlays(
      tester,
      fakeAppConfig(update: _updateAvailable, welcome: _banner),
    );

    expect(find.byType(UpdateAvailableSheet), findsOneWidget);
    expect(find.byType(WelcomeBannerDialog), findsNothing);

    await tester.tap(find.text(RemoteConfigStrings.updateAvailableLater));
    await tester.pumpAndSettle();

    verify(() => repository.dismissUpdate('2.0.0')).called(1);
    expect(find.byType(WelcomeBannerDialog), findsNothing);
  });

  testWidgets('shows the welcome dialog when no update applies', (
    tester,
  ) async {
    await pumpOverlays(tester, fakeAppConfig(welcome: _banner));

    expect(find.byType(WelcomeBannerDialog), findsOneWidget);

    await tester.tap(find.text(RemoteConfigStrings.welcomeDialogClose));
    await tester.pumpAndSettle();

    verify(() => repository.markWelcomeSeen(any())).called(1);
  });

  testWidgets('shows nothing when both were already seen or are off', (
    tester,
  ) async {
    await pumpOverlays(tester, fakeAppConfig());

    expect(find.byType(UpdateAvailableSheet), findsNothing);
    expect(find.byType(WelcomeBannerDialog), findsNothing);
  });

  testWidgets('reacts when the config arrives after the first build', (
    tester,
  ) async {
    await pumpOverlays(tester, null);

    await pumpOverlays(tester, fakeAppConfig(welcome: _banner));

    expect(find.byType(WelcomeBannerDialog), findsOneWidget);
  });
}
