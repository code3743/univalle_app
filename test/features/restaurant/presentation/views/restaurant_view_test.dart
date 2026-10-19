import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/app_strings.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/core/router/app_routes.dart';
import 'package:univalle_app/core/widgets/shortcut_card.dart';
import 'package:univalle_app/features/restaurant/domain/entities/restaurant_account.dart';
import 'package:univalle_app/features/restaurant/presentation/providers/restaurant_providers.dart';
import 'package:univalle_app/features/restaurant/presentation/views/restaurant_view.dart';
import 'package:univalle_app/features/restaurant/presentation/widgets/buy_lunches_form.dart';
import 'package:univalle_app/features/restaurant/presentation/widgets/lunch_ticket_card/lunch_ticket_card.dart';
import 'package:univalle_app/features/restaurant/presentation/widgets/restaurant_skeleton.dart';
import 'package:univalle_app/features/restaurant/restaurant_strings.dart';

import '../../../../helpers/pump_app.dart';
import '../restaurant_fixtures.dart';

void main() {
  late MockRestaurantRepository repository;

  setUp(() {
    repository = MockRestaurantRepository();
  });

  Future<void> pumpView(WidgetTester tester) async {
    await tester.pumpRoutedApp(
      const RestaurantView(),
      overrides: [restaurantRepositoryProvider.overrideWithValue(repository)],
    );
    await tester.pump();
  }

  testWidgets('shows a skeleton while the account loads', (tester) async {
    final completer = Completer<Result<RestaurantAccount>>();
    when(() => repository.getAccount()).thenAnswer((_) => completer.future);

    await pumpView(tester);

    expect(find.byType(RestaurantSkeleton), findsOneWidget);
    completer.complete(Ok(account()));
    await tester.pumpAndSettle();
  });

  testWidgets(
    'shows the ticket and the purchase form without a pending payment',
    (tester) async {
      when(() => repository.getAccount())
          .thenAnswer((_) async => Ok(account()));

      await pumpView(tester);
      await tester.pumpAndSettle();

      expect(find.byType(LunchTicketCard), findsOneWidget);
      expect(find.byType(BuyLunchesForm), findsOneWidget);
      expect(find.text(RestaurantStrings.cafeteriaOnlyNotice), findsOneWidget);
      expect(find.text(RestaurantStrings.noPaymentDisclaimer), findsOneWidget);
    },
  );

  testWidgets(
    'offers the pending payment instead of the form when one exists',
    (tester) async {
      when(() => repository.getAccount())
          .thenAnswer((_) async => Ok(account(pending: pendingPayment)));

      await pumpView(tester);
      await tester.pumpAndSettle();

      expect(find.byType(BuyLunchesForm), findsNothing);

      await tester.tap(find.byType(ShortcutCard));
      await tester.pumpAndSettle();

      expect(find.text('route:${AppRoutes.pendingPayment}'), findsOneWidget);
    },
  );

  testWidgets('shows the failure and retries', (tester) async {
    when(() => repository.getAccount())
        .thenAnswer((_) async => Err(NetworkFailure(message: 'down')));

    await pumpView(tester);
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.networkError), findsOneWidget);

    when(() => repository.getAccount()).thenAnswer((_) async => Ok(account()));
    await tester.tap(find.text(AppStrings.retry));
    await tester.pumpAndSettle();

    expect(find.byType(LunchTicketCard), findsOneWidget);
  });
}
