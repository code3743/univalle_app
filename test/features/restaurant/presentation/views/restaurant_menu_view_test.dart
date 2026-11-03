import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/restaurant_constants.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/core/router/app_routes.dart';
import 'package:univalle_app/core/widgets/shortcut_card.dart';
import 'package:univalle_app/features/restaurant/domain/entities/weekly_menu.dart';
import 'package:univalle_app/features/restaurant/domain/repositories/restaurant_menu_repository.dart';
import 'package:univalle_app/features/restaurant/di/restaurant_providers.dart';
import 'package:univalle_app/features/restaurant/presentation/views/restaurant_menu_view.dart';
import 'package:univalle_app/features/restaurant/presentation/widgets/weekly_menu/menu_skeleton.dart';
import 'package:univalle_app/features/restaurant/presentation/widgets/weekly_menu/weekly_menu_section.dart';
import 'package:univalle_app/features/restaurant/restaurant_strings.dart';

import '../../../../helpers/fake_url_launcher.dart';
import '../../../../helpers/pump_app.dart';

class MockMenuRepository extends Mock implements RestaurantMenuRepository {}

const _menu = WeeklyMenu(
  weekLabel: 'Lunes 02 al viernes 06 de noviembre de 2026',
  days: [
    DailyMenu(dayLabel: 'Lunes 02', closedReason: 'FESTIVO'),
    DailyMenu(
      dayLabel: 'Martes 03',
      dishes: [
        MenuDish(category: 'Sopa', name: 'De lentejas'),
        MenuDish(category: 'Carne', name: 'Bistec'),
      ],
    ),
  ],
);

void main() {
  late MockMenuRepository repository;

  setUp(() => repository = MockMenuRepository());

  Future<void> pumpView(WidgetTester tester) async {
    await tester.pumpRoutedApp(
      const RestaurantMenuView(),
      overrides: [
        restaurantMenuRepositoryProvider.overrideWithValue(repository),
      ],
    );
    await tester.pump();
  }

  testWidgets('shows a skeleton while the menu loads', (tester) async {
    final completer = Completer<Result<WeeklyMenu>>();
    when(() => repository.getWeeklyMenu()).thenAnswer((_) => completer.future);

    await pumpView(tester);

    expect(find.byType(MenuSkeleton), findsOneWidget);
    completer.complete(const Ok(_menu));
    await tester.pumpAndSettle();
  });

  testWidgets('shows the menu and switches between days', (tester) async {
    when(() => repository.getWeeklyMenu())
        .thenAnswer((_) async => const Ok(_menu));

    await pumpView(tester);
    await tester.pumpAndSettle();

    expect(find.byType(WeeklyMenuSection), findsOneWidget);
    await tester.tap(find.text('03'));
    await tester.pump();
    expect(find.text('De lentejas'), findsOneWidget);

    await tester.tap(find.text('02'));
    await tester.pump();
    expect(find.text(RestaurantStrings.noService('FESTIVO')), findsOneWidget);
  });

  testWidgets('keeps the buy button when the menu fails', (tester) async {
    when(() => repository.getWeeklyMenu()).thenAnswer(
      (_) async => Err(ServerFailure(message: 'boom', statusCode: 500)),
    );

    await pumpView(tester);
    await tester.pumpAndSettle();

    expect(find.byType(WeeklyMenuSection), findsNothing);
    expect(find.byType(ShortcutCard), findsOneWidget);
  });

  testWidgets('opens the ticket flow from the buy button', (tester) async {
    when(() => repository.getWeeklyMenu())
        .thenAnswer((_) async => const Ok(_menu));

    await pumpView(tester);
    await tester.pumpAndSettle();
    await tester.tap(find.text(RestaurantStrings.buyTicketsLabel));
    await tester.pumpAndSettle();

    expect(find.text('route:${AppRoutes.restaurantTickets}'), findsOneWidget);
  });

  testWidgets('keeps the site link visible when the menu fails', (
    tester,
  ) async {
    final launcher = FakeUrlLauncher.install();
    when(() => repository.getWeeklyMenu()).thenAnswer(
      (_) async => Err(ServerFailure(message: 'boom', statusCode: 500)),
    );

    await pumpView(tester);
    await tester.pumpAndSettle();
    await tester.tap(find.text(RestaurantStrings.menuSiteLabel));
    await tester.pump();

    expect(launcher.launched, [RestaurantConstants.menuUrl]);
  });

  testWidgets('tells the user when the site cannot be opened', (tester) async {
    FakeUrlLauncher.install(canOpen: false);
    when(() => repository.getWeeklyMenu())
        .thenAnswer((_) async => const Ok(_menu));

    await pumpView(tester);
    await tester.pumpAndSettle();
    await tester.tap(find.text(RestaurantStrings.menuSiteLabel));
    await tester.pump();

    expect(find.text(RestaurantStrings.cannotOpenMenuSite), findsOneWidget);
  });
}
