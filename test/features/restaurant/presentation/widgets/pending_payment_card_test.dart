import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/app_strings.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/restaurant/presentation/providers/restaurant_providers.dart';
import 'package:univalle_app/features/restaurant/presentation/utils/lunch_money_formatter.dart';
import 'package:univalle_app/features/restaurant/presentation/viewmodels/restaurant_view_model.dart';
import 'package:univalle_app/features/restaurant/presentation/widgets/pending_payment_card.dart';
import 'package:univalle_app/features/restaurant/restaurant_strings.dart';

import '../../../../helpers/fake_url_launcher.dart';
import '../../../../helpers/pump_app.dart';
import '../restaurant_fixtures.dart';

void main() {
  late MockRestaurantRepository repository;
  late FakeUrlLauncher launcher;

  setUp(() {
    repository = MockRestaurantRepository();
    launcher = FakeUrlLauncher.install();
  });

  // The card only reads the notifier, while the real screen keeps the
  // auto-disposed view model alive by watching it — so the test holds it too.
  Future<void> pumpCard(WidgetTester tester) async {
    when(() => repository.getAccount())
        .thenAnswer((_) async => Ok(account(pending: pendingPayment)));
    await tester.pumpApp(
      const PendingPaymentCard(payment: pendingPayment),
      overrides: [restaurantRepositoryProvider.overrideWithValue(repository)],
    );
    final container = ProviderScope.containerOf(
      tester.element(find.byType(PendingPaymentCard)),
    );
    final subscription = container.listen(
      restaurantViewModelProvider,
      (_, _) {},
    );
    addTearDown(subscription.close);
    await container.read(restaurantViewModelProvider.future);
  }

  testWidgets('shows the payment details and message', (tester) async {
    await pumpCard(tester);

    expect(find.text('2026-01-01'), findsOneWidget);
    expect(find.text('2026-01-02'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text(LunchMoneyFormatter.format(10500)), findsOneWidget);
    expect(find.text('Tienes un pago en proceso'), findsOneWidget);
  });

  testWidgets('opens the payment link externally', (tester) async {
    await pumpCard(tester);

    await tester.tap(find.text(RestaurantStrings.goToPayLabel));
    await tester.pump();

    expect(launcher.launched, ['https://pay.example/1']);
    expect(find.text(RestaurantStrings.cannotOpenPaymentLink), findsNothing);
  });

  testWidgets('tells the user when the link cannot be opened', (tester) async {
    FakeUrlLauncher.install(canOpen: false);
    await pumpCard(tester);

    await tester.tap(find.text(RestaurantStrings.goToPayLabel));
    await tester.pump();

    expect(find.text(RestaurantStrings.cannotOpenPaymentLink), findsOneWidget);
  });

  testWidgets('confirms the payment when the lunch count grew', (tester) async {
    await pumpCard(tester);
    when(() => repository.getAccount())
        .thenAnswer((_) async => Ok(account(accumulatedLunches: 7)));

    await tester.tap(find.text(RestaurantStrings.confirmPaymentLabel));
    await tester.pump();
    await tester.pump();

    expect(find.text(RestaurantStrings.paymentConfirmed), findsOneWidget);
  });

  testWidgets('says the payment is still pending when nothing changed', (
    tester,
  ) async {
    await pumpCard(tester);

    await tester.tap(find.text(RestaurantStrings.confirmPaymentLabel));
    await tester.pump();
    await tester.pump();

    expect(find.text(RestaurantStrings.paymentStillPending), findsOneWidget);
  });

  testWidgets('shows the failure message when confirming fails', (
    tester,
  ) async {
    await pumpCard(tester);
    when(() => repository.getAccount())
        .thenAnswer((_) async => Err(NetworkFailure(message: 'down')));

    await tester.tap(find.text(RestaurantStrings.confirmPaymentLabel));
    await tester.pump();
    await tester.pump();

    expect(find.text(AppStrings.networkError), findsOneWidget);
  });
}
