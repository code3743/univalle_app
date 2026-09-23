import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/home/home_strings.dart';
import 'package:univalle_app/features/home/presentation/widgets/quick_access_items.dart';
import 'package:univalle_app/features/remote_config/domain/entities/app_config.dart';
import 'package:univalle_app/features/remote_config/domain/entities/app_module.dart';
import 'package:univalle_app/features/remote_config/domain/entities/welcome_banner.dart';

import '../../../../helpers/pump_app.dart';

AppModule _module(
  String key, {
  String route = '/unknown-route',
  bool disabled = false,
  String? disabledMessage,
}) => AppModule(
  key: key,
  label: key,
  icon: 'unknown-icon',
  route: route,
  color: '#FF0000',
  disabled: disabled,
  disabledMessage: disabledMessage,
);

AppConfig _config(List<AppModule> modules, List<String> quickAccess) =>
    AppConfig(
      platformEnabled: true,
      maintenance: const MaintenanceStatus(
        enabled: false,
        title: '',
        message: '',
      ),
      update: const UpdateStatus(
        latestVersion: '1.0.0',
        updateAvailable: false,
        updateRequired: false,
        storeUrl: '',
        message: '',
      ),
      modules: modules,
      quickAccess: quickAccess,
      welcome: const WelcomeBanner(enabled: false, title: '', description: ''),
    );

Future<List<QuickAccessItem>> _itemsFrom(
  WidgetTester tester,
  AppConfig config,
) async {
  late List<QuickAccessItem> items;
  await tester.pumpApp(
    Builder(
      builder: (context) {
        items = quickAccessItems(context, config);
        return const SizedBox.shrink();
      },
    ),
  );
  return items;
}

void main() {
  testWidgets('orders modules by quickAccess, then the rest', (tester) async {
    final config = _config(
      [_module('b'), _module('a'), _module('c')],
      ['a', 'c'],
    );

    final items = await _itemsFrom(tester, config);

    expect(items.map((i) => i.key), ['a', 'c', 'b']);
  });

  testWidgets('a disabled module shows its custom disabledMessage on tap', (
    tester,
  ) async {
    final config = _config([
      _module('a', disabled: true, disabledMessage: 'Mantenimiento programado'),
    ], []);
    final items = await _itemsFrom(tester, config);

    await tester.pumpApp(
      Builder(
        builder: (context) =>
            GestureDetector(onTap: items.first.onTap, child: const Text('x')),
      ),
    );
    await tester.tap(find.text('x'));
    await tester.pumpAndSettle();

    expect(find.text('Mantenimiento programado'), findsOneWidget);
  });

  testWidgets('a disabled module without a message falls back to comingSoon', (
    tester,
  ) async {
    final config = _config([_module('a', disabled: true)], []);
    final items = await _itemsFrom(tester, config);

    await tester.pumpApp(
      Builder(
        builder: (context) =>
            GestureDetector(onTap: items.first.onTap, child: const Text('x')),
      ),
    );
    await tester.tap(find.text('x'));
    await tester.pumpAndSettle();

    expect(find.text(HomeStrings.comingSoon), findsOneWidget);
  });

  testWidgets('a module pointing at an unknown route shows comingSoon', (
    tester,
  ) async {
    final config = _config([_module('a', route: '/not-implemented')], []);
    final items = await _itemsFrom(tester, config);

    await tester.pumpApp(
      Builder(
        builder: (context) =>
            GestureDetector(onTap: items.first.onTap, child: const Text('x')),
      ),
    );
    await tester.tap(find.text('x'));
    await tester.pumpAndSettle();

    expect(find.text(HomeStrings.comingSoon), findsOneWidget);
  });
}
