import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:univalle_app/core/device/app_platform_provider.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/core/router/app_router.dart';
import 'package:univalle_app/core/router/app_routes.dart';
import 'package:univalle_app/core/theme/app_theme.dart';
import 'package:univalle_app/features/auth/domain/entities/auth_session.dart';
import 'package:univalle_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:univalle_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:univalle_app/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:univalle_app/features/remote_config/domain/entities/app_config.dart';
import 'package:univalle_app/features/remote_config/domain/entities/welcome_banner.dart';
import 'package:univalle_app/features/remote_config/domain/repositories/remote_config_repository.dart';
import 'package:univalle_app/features/remote_config/presentation/providers/remote_config_providers.dart';

import '../../helpers/container.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockRemoteConfigRepository extends Mock
    implements RemoteConfigRepository {}

AppConfig _config() => const AppConfig(
  platformEnabled: true,
  maintenance: MaintenanceStatus(enabled: false, title: '', message: ''),
  update: UpdateStatus(
    latestVersion: '1.0.0',
    updateAvailable: false,
    updateRequired: false,
    storeUrl: '',
    message: '',
  ),
  modules: [],
  quickAccess: [],
  welcome: WelcomeBanner(enabled: false, title: '', description: ''),
);

// `Provider<Ref>` autodisposes like everything else in riverpod 3 by
// default; `keepAlive()` keeps the extracted `Ref` usable for the rest of
// the test instead of it going stale the instant nothing else reads it.
final _refProvider = Provider<Ref>((ref) {
  ref.keepAlive();
  return ref;
});

GoRouter _buildTestRouter(ProviderContainer container, String initialLocation) {
  final ref = container.read(_refProvider);
  final refresh = AuthRefreshNotifier(ref);
  return GoRouter(
    initialLocation: initialLocation,
    refreshListenable: refresh,
    redirect: (context, state) => appRouterRedirect(ref, state),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, _) => const SizedBox.shrink(),
      ),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const Text('LOGIN')),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (_, _) => const Text('FORGOT'),
      ),
      GoRoute(path: AppRoutes.home, builder: (_, _) => const Text('HOME')),
      GoRoute(
        path: AppRoutes.profile,
        builder: (_, _) => const Text('PROFILE'),
      ),
    ],
  );
}

Future<ProviderContainer> _pump(
  WidgetTester tester, {
  required MockAuthRepository authRepository,
  required MockRemoteConfigRepository remoteConfigRepository,
  String initialLocation = AppRoutes.splash,
}) async {
  final container = createContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      remoteConfigRepositoryProvider.overrideWithValue(remoteConfigRepository),
      appPlatformProvider.overrideWithValue('android'),
    ],
  );
  final router = _buildTestRouter(container, initialLocation);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    ),
  );
  return container;
}

void main() {
  setUp(() {
    PackageInfo.setMockInitialValues(
      appName: 'Univalle App',
      packageName: 'co.edu.univalle.univalle_app',
      version: '0.1.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  testWidgets('without a session, a protected route redirects to Login', (
    tester,
  ) async {
    final authRepository = MockAuthRepository();
    final remoteConfigRepository = MockRemoteConfigRepository();
    when(() => authRepository.restoreSession())
        .thenAnswer((_) async => const Ok(null));
    when(
      () => remoteConfigRepository.getConfig(
        platform: any(named: 'platform'),
        version: any(named: 'version'),
      ),
    ).thenAnswer((_) async => Ok(_config()));

    await _pump(
      tester,
      authRepository: authRepository,
      remoteConfigRepository: remoteConfigRepository,
      initialLocation: AppRoutes.profile,
    );
    await tester.pumpAndSettle();

    expect(find.text('LOGIN'), findsOneWidget);
    expect(find.text('PROFILE'), findsNothing);
  });

  testWidgets('with a session, visiting Login redirects to Home', (
    tester,
  ) async {
    final authRepository = MockAuthRepository();
    final remoteConfigRepository = MockRemoteConfigRepository();
    when(() => authRepository.restoreSession())
        .thenAnswer((_) async => const Ok(AuthSession(username: 'jperez')));
    when(
      () => remoteConfigRepository.getConfig(
        platform: any(named: 'platform'),
        version: any(named: 'version'),
      ),
    ).thenAnswer((_) async => Ok(_config()));

    await _pump(
      tester,
      authRepository: authRepository,
      remoteConfigRepository: remoteConfigRepository,
      initialLocation: AppRoutes.login,
    );
    await tester.pumpAndSettle();

    expect(find.text('HOME'), findsOneWidget);
  });

  testWidgets('logging out from a protected route redirects to Login', (
    tester,
  ) async {
    final authRepository = MockAuthRepository();
    final remoteConfigRepository = MockRemoteConfigRepository();
    when(() => authRepository.restoreSession())
        .thenAnswer((_) async => const Ok(AuthSession(username: 'jperez')));
    when(
      () => remoteConfigRepository.getConfig(
        platform: any(named: 'platform'),
        version: any(named: 'version'),
      ),
    ).thenAnswer((_) async => Ok(_config()));
    when(() => authRepository.logout()).thenAnswer((_) async => const Ok(null));

    final container = await _pump(
      tester,
      authRepository: authRepository,
      remoteConfigRepository: remoteConfigRepository,
      initialLocation: AppRoutes.profile,
    );
    await tester.pumpAndSettle();
    expect(find.text('PROFILE'), findsOneWidget);

    await container.read(authViewModelProvider.notifier).logout();
    await tester.pumpAndSettle();

    expect(find.text('LOGIN'), findsOneWidget);
  });

  testWidgets(
    'forgot-password stays reachable without a session (no redirect either way)',
    (tester) async {
      final authRepository = MockAuthRepository();
      final remoteConfigRepository = MockRemoteConfigRepository();
      when(() => authRepository.restoreSession())
          .thenAnswer((_) async => const Ok(null));
      when(
        () => remoteConfigRepository.getConfig(
          platform: any(named: 'platform'),
          version: any(named: 'version'),
        ),
      ).thenAnswer((_) async => Ok(_config()));

      await _pump(
        tester,
        authRepository: authRepository,
        remoteConfigRepository: remoteConfigRepository,
        initialLocation: AppRoutes.forgotPassword,
      );
      await tester.pumpAndSettle();

      expect(find.text('FORGOT'), findsOneWidget);
    },
  );

  testWidgets('stays on splash until auth and config settle, then routes', (
    tester,
  ) async {
    final authRepository = MockAuthRepository();
    final remoteConfigRepository = MockRemoteConfigRepository();
    final authCompleter = Completer<Result<AuthSession?>>();
    when(() => authRepository.restoreSession())
        .thenAnswer((_) => authCompleter.future);
    when(
      () => remoteConfigRepository.getConfig(
        platform: any(named: 'platform'),
        version: any(named: 'version'),
      ),
    ).thenAnswer((_) async => Ok(_config()));

    await _pump(
      tester,
      authRepository: authRepository,
      remoteConfigRepository: remoteConfigRepository,
    );
    await tester.pump();

    expect(find.text('LOGIN'), findsNothing);
    expect(find.text('HOME'), findsNothing);

    authCompleter.complete(const Ok(null));
    await tester.pumpAndSettle();

    expect(find.text('LOGIN'), findsOneWidget);
  });
}
