import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/domain/entities/app_config.dart';
import 'package:univalle_app/core/widgets/user_avatar.dart';
import 'package:univalle_app/features/home/home_strings.dart';
import 'package:univalle_app/features/home/presentation/widgets/home_greeting.dart';
import 'package:univalle_app/features/home/presentation/widgets/home_quick_access.dart';
import 'package:univalle_app/features/home/presentation/widgets/home_top_bar.dart';
import 'package:univalle_app/features/home/presentation/widgets/program_card.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/pump_app.dart';

AppConfig _config(int enabledModules, {int disabledModules = 0}) =>
    fakeAppConfig(
      modules: [
        for (var i = 0; i < enabledModules; i++)
          fakeAppModule(key: 'm$i', label: 'Módulo $i', route: '/grades'),
        for (var i = 0; i < disabledModules; i++)
          fakeAppModule(key: 'd$i', label: 'Apagado $i', disabled: true),
      ],
      quickAccess: [for (var i = 0; i < enabledModules; i++) 'm$i'],
    );

void main() {
  testWidgets('HomeGreeting greets the student by first name', (tester) async {
    await tester.pumpApp(const HomeGreeting(firstName: 'Juan'));

    expect(find.text(HomeStrings.greeting), findsOneWidget);
    expect(find.text('Juan 👋'), findsOneWidget);
    expect(find.text(HomeStrings.tagline), findsOneWidget);
  });

  testWidgets('HomeTopBar wires the bell and the avatar', (tester) async {
    var bell = 0;
    var avatar = 0;
    await tester.pumpApp(
      HomeTopBar(
        onNotifications: () => bell++,
        onAvatarTap: () => avatar++,
        initial: 'J',
      ),
    );

    expect(find.text('J'), findsOneWidget);
    expect(find.byType(UserAvatar), findsOneWidget);

    await tester.tap(find.byIcon(Icons.notifications_none));
    await tester.tap(find.byType(UserAvatar));

    expect(bell, 1);
    expect(avatar, 1);
  });

  testWidgets('ProgramCard shows the program, campus and semester', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpApp(
      ProgramCard(
        student: fakeStudent(),
        currentSemester: '2026-1',
        onTap: () => tapped = true,
      ),
    );

    expect(find.text('Ingeniería de Sistemas'), findsOneWidget);
    expect(find.text('Meléndez'), findsOneWidget);
    expect(
      find.text('${HomeStrings.currentSemesterLabel} 2026-1'),
      findsOneWidget,
    );

    await tester.tap(find.byType(ProgramCard));
    expect(tapped, isTrue);
  });

  group('HomeQuickAccess', () {
    Future<void> pumpQuickAccess(
      WidgetTester tester,
      AsyncValue<AppConfig?> config, {
      VoidCallback? onViewAll,
    }) => tester.pumpRoutedApp(
      SingleChildScrollView(
        child: HomeQuickAccess(
          config: config,
          onViewAll: onViewAll ?? () {},
          onRetry: () {},
        ),
      ),
    );

    testWidgets('shows at most six shortcuts and the "view all" link', (
      tester,
    ) async {
      var viewedAll = false;
      await pumpQuickAccess(
        tester,
        AsyncData(_config(8)),
        onViewAll: () => viewedAll = true,
      );

      expect(find.text('Módulo 0'), findsOneWidget);
      expect(find.text('Módulo 5'), findsOneWidget);
      expect(find.text('Módulo 6'), findsNothing);

      await tester.tap(find.text(HomeStrings.viewAll));
      expect(viewedAll, isTrue);
    });

    testWidgets('hides disabled modules from the grid', (tester) async {
      await pumpQuickAccess(tester, AsyncData(_config(2, disabledModules: 1)));

      expect(find.text('Módulo 0'), findsOneWidget);
      expect(find.text('Apagado 0'), findsNothing);
    });

    testWidgets('has no "view all" link when nothing is enabled', (
      tester,
    ) async {
      await pumpQuickAccess(tester, AsyncData(_config(0, disabledModules: 2)));

      expect(find.text(HomeStrings.viewAll), findsNothing);
      expect(find.text(HomeStrings.modulesEmptyTitle), findsOneWidget);
    });

    testWidgets('has no "view all" link while the config is unavailable', (
      tester,
    ) async {
      await pumpQuickAccess(tester, const AsyncData(null));

      expect(find.text(HomeStrings.viewAll), findsNothing);
      expect(find.text(HomeStrings.modulesUnavailableTitle), findsOneWidget);
    });
  });
}
