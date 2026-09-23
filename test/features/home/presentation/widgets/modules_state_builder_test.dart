import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/constants/app_strings.dart';
import 'package:univalle_app/features/home/home_strings.dart';
import 'package:univalle_app/features/home/presentation/widgets/modules_state_builder.dart';
import 'package:univalle_app/features/home/presentation/widgets/quick_access_items.dart';
import 'package:univalle_app/features/home/presentation/widgets/quick_access_skeleton.dart';
import 'package:univalle_app/features/remote_config/domain/entities/app_config.dart';
import 'package:univalle_app/features/remote_config/domain/entities/app_module.dart';
import 'package:univalle_app/features/remote_config/domain/entities/welcome_banner.dart';

import '../../../../helpers/pump_app.dart';

AppModule _module(String key, {bool disabled = false}) => AppModule(
  key: key,
  label: key,
  icon: 'unknown-icon',
  route: '/unknown',
  color: '#FF0000',
  disabled: disabled,
);

AppConfig _config(List<AppModule> modules) => AppConfig(
  platformEnabled: true,
  maintenance: const MaintenanceStatus(enabled: false, title: '', message: ''),
  update: const UpdateStatus(
    latestVersion: '1.0.0',
    updateAvailable: false,
    updateRequired: false,
    storeUrl: '',
    message: '',
  ),
  modules: modules,
  quickAccess: [],
  welcome: const WelcomeBanner(enabled: false, title: '', description: ''),
);

Widget _grid(BuildContext context, List<QuickAccessItem> items) =>
    Text('items:${items.length}');

void main() {
  testWidgets('loading with no prior value shows the loading skeleton', (
    tester,
  ) async {
    await tester.pumpApp(
      ModulesStateBuilder(
        config: const AsyncLoading<AppConfig?>(),
        onRetry: () {},
        builder: _grid,
      ),
    );

    expect(find.byType(QuickAccessSkeleton), findsOneWidget);
  });

  testWidgets('a null config shows the unavailable state with a retry button', (
    tester,
  ) async {
    var retried = false;
    await tester.pumpApp(
      ModulesStateBuilder(
        config: const AsyncData<AppConfig?>(null),
        onRetry: () => retried = true,
        builder: _grid,
      ),
    );

    expect(find.text(HomeStrings.modulesUnavailableTitle), findsOneWidget);

    await tester.tap(find.text(AppStrings.retry));
    expect(retried, isTrue);
  });

  testWidgets('a config with no modules shows the empty state without retry', (
    tester,
  ) async {
    await tester.pumpApp(
      ModulesStateBuilder(
        config: AsyncData<AppConfig?>(_config([])),
        onRetry: () {},
        builder: _grid,
      ),
    );

    expect(find.text(HomeStrings.modulesEmptyTitle), findsOneWidget);
    expect(find.text(AppStrings.retry), findsNothing);
  });

  testWidgets('a filter that removes every module shows the empty state', (
    tester,
  ) async {
    await tester.pumpApp(
      ModulesStateBuilder(
        config: AsyncData<AppConfig?>(_config([_module('a', disabled: true)])),
        onRetry: () {},
        filter: (item) => !item.disabled,
        builder: _grid,
      ),
    );

    expect(find.text(HomeStrings.modulesEmptyTitle), findsOneWidget);
  });

  testWidgets('retrying after a null config keeps showing the loading skeleton '
      'until the retry resolves', (tester) async {
    var callCount = 0;
    late Completer<AppConfig?> retryCompleter;
    final configProvider = FutureProvider.autoDispose<AppConfig?>((ref) {
      callCount++;
      if (callCount == 1) return Future.value(null);
      retryCompleter = Completer<AppConfig?>();
      return retryCompleter.future;
    });

    await tester.pumpApp(
      Consumer(
        builder: (context, ref, _) => ModulesStateBuilder(
          config: ref.watch(configProvider),
          onRetry: () => ref.invalidate(configProvider),
          builder: _grid,
        ),
      ),
    );
    await tester.pump();

    expect(find.text(HomeStrings.modulesUnavailableTitle), findsOneWidget);

    await tester.tap(find.text(AppStrings.retry));
    await tester.pump();

    expect(find.byType(QuickAccessSkeleton), findsOneWidget);
    expect(find.text(HomeStrings.modulesUnavailableTitle), findsNothing);

    retryCompleter.complete(_config([_module('a')]));
    await tester.pumpAndSettle();

    expect(find.text('items:1'), findsOneWidget);
  });

  testWidgets('modules present builds the grid with them', (tester) async {
    await tester.pumpApp(
      ModulesStateBuilder(
        config: AsyncData<AppConfig?>(_config([_module('a'), _module('b')])),
        onRetry: () {},
        builder: _grid,
      ),
    );

    expect(find.text('items:2'), findsOneWidget);
  });
}
