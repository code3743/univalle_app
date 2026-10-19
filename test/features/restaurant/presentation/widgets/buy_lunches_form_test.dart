import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/app_strings.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/core/router/app_routes.dart';
import 'package:univalle_app/features/restaurant/presentation/providers/restaurant_providers.dart';
import 'package:univalle_app/features/restaurant/presentation/utils/lunch_money_formatter.dart';
import 'package:univalle_app/features/restaurant/presentation/widgets/buy_lunches_form.dart';
import 'package:univalle_app/features/restaurant/restaurant_strings.dart';

import '../../../../helpers/pump_app.dart';
import '../restaurant_fixtures.dart';

void main() {
  late MockRestaurantRepository repository;

  setUp(() {
    repository = MockRestaurantRepository();
  });

  Future<void> pumpForm(WidgetTester tester) async {
    await tester.pumpRoutedApp(
      SingleChildScrollView(child: BuyLunchesForm(account: account())),
      overrides: [restaurantRepositoryProvider.overrideWithValue(repository)],
    );
  }

  testWidgets('starts at the minimum purchase with its total', (tester) async {
    await pumpForm(tester);

    expect(find.widgetWithText(TextFormField, '2'), findsOneWidget);
    expect(find.text(LunchMoneyFormatter.format(7000)), findsOneWidget);
  });

  testWidgets('the stepper buttons update the quantity and total', (
    tester,
  ) async {
    await pumpForm(tester);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.widgetWithText(TextFormField, '3'), findsOneWidget);
    expect(find.text(LunchMoneyFormatter.format(10500)), findsOneWidget);

    await tester.tap(find.byIcon(Icons.remove));
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();

    expect(find.widgetWithText(TextFormField, '2'), findsOneWidget);
  });

  testWidgets('validates empty, non-numeric, below-min and above-max input', (
    tester,
  ) async {
    await pumpForm(tester);
    final field = find.byType(TextFormField);

    await tester.enterText(field, '');
    await tester.pump();
    expect(find.text(RestaurantStrings.quantityRequired), findsOneWidget);

    await tester.enterText(field, 'abc');
    await tester.pump();
    expect(find.text(RestaurantStrings.quantityInvalid), findsOneWidget);

    await tester.enterText(field, '1');
    await tester.pump();
    expect(find.text(RestaurantStrings.quantityBelowMin(2)), findsOneWidget);

    await tester.enterText(field, '11');
    await tester.pump();
    expect(find.text(RestaurantStrings.quantityAboveMax(10)), findsOneWidget);
  });

  testWidgets('does not buy when the input is invalid', (tester) async {
    await pumpForm(tester);

    await tester.enterText(find.byType(TextFormField), '99');
    await tester.tap(find.text(RestaurantStrings.buySubmit));
    await tester.pumpAndSettle();

    expect(find.text(RestaurantStrings.confirmPurchaseTitle), findsNothing);
    verifyNever(
      () => repository.buyLunches(
        quantity: any(named: 'quantity'),
        total: any(named: 'total'),
      ),
    );
  });

  testWidgets('does not buy when the confirmation is cancelled', (
    tester,
  ) async {
    await pumpForm(tester);

    await tester.tap(find.text(RestaurantStrings.buySubmit));
    await tester.pumpAndSettle();
    await tester.tap(find.text(RestaurantStrings.cancelLabel));
    await tester.pumpAndSettle();

    verifyNever(
      () => repository.buyLunches(
        quantity: any(named: 'quantity'),
        total: any(named: 'total'),
      ),
    );
  });

  testWidgets('buys after confirming and opens the pending payment', (
    tester,
  ) async {
    when(() => repository.buyLunches(quantity: 2, total: 7000))
        .thenAnswer((_) async => const Ok(pendingPayment));
    when(() => repository.getAccount()).thenAnswer((_) async => Ok(account()));
    await pumpForm(tester);

    await tester.tap(find.text(RestaurantStrings.buySubmit));
    await tester.pumpAndSettle();
    await tester.tap(find.text(RestaurantStrings.confirmLabel));
    await tester.pumpAndSettle();

    verify(() => repository.buyLunches(quantity: 2, total: 7000)).called(1);
    expect(find.text('route:${AppRoutes.pendingPayment}'), findsOneWidget);
  });

  testWidgets('shows the failure message when the purchase fails', (
    tester,
  ) async {
    when(() => repository.buyLunches(quantity: 2, total: 7000))
        .thenAnswer((_) async => Err(NetworkFailure(message: 'down')));
    await pumpForm(tester);

    await tester.tap(find.text(RestaurantStrings.buySubmit));
    await tester.pumpAndSettle();
    await tester.tap(find.text(RestaurantStrings.confirmLabel));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.networkError), findsOneWidget);
    expect(find.text('route:${AppRoutes.pendingPayment}'), findsNothing);
  });
}
