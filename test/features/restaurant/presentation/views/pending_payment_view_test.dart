import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/core/router/app_routes.dart';
import 'package:univalle_app/features/restaurant/presentation/providers/restaurant_providers.dart';
import 'package:univalle_app/features/restaurant/presentation/views/pending_payment_view.dart';
import 'package:univalle_app/features/restaurant/presentation/viewmodels/restaurant_view_model.dart';
import 'package:univalle_app/features/restaurant/presentation/widgets/pending_payment_card.dart';
import 'package:univalle_app/features/restaurant/restaurant_strings.dart';

import '../../../../helpers/pump_app.dart';
import '../restaurant_fixtures.dart';

void main() {
  late MockRestaurantRepository repository;

  setUp(() {
    repository = MockRestaurantRepository();
  });

  testWidgets('shows the pending payment card', (tester) async {
    when(() => repository.getAccount())
        .thenAnswer((_) async => Ok(account(pending: pendingPayment)));

    await tester.pumpApp(
      const PendingPaymentView(),
      overrides: [restaurantRepositoryProvider.overrideWithValue(repository)],
    );
    await tester.pumpAndSettle();

    expect(find.text(RestaurantStrings.pendingPaymentTitle), findsOneWidget);
    expect(find.byType(PendingPaymentCard), findsOneWidget);
  });

  testWidgets('renders nothing when there is no pending payment', (
    tester,
  ) async {
    when(() => repository.getAccount()).thenAnswer((_) async => Ok(account()));

    await tester.pumpApp(
      const PendingPaymentView(),
      overrides: [restaurantRepositoryProvider.overrideWithValue(repository)],
    );
    await tester.pumpAndSettle();

    expect(find.byType(PendingPaymentCard), findsNothing);
  });

  testWidgets('pops once the payment is no longer pending', (tester) async {
    when(() => repository.getAccount())
        .thenAnswer((_) async => Ok(account(pending: pendingPayment)));
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const Text('home')),
        GoRoute(
          path: AppRoutes.pendingPayment,
          builder: (_, _) => const PendingPaymentView(),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [restaurantRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    unawaited(router.push(AppRoutes.pendingPayment));
    await tester.pumpAndSettle();
    expect(find.byType(PendingPaymentCard), findsOneWidget);

    when(() => repository.getAccount()).thenAnswer((_) async => Ok(account()));
    final container = ProviderScope.containerOf(
      tester.element(find.byType(PendingPaymentView)),
    );
    await container.read(restaurantViewModelProvider.notifier).confirmPayment();
    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
    expect(find.byType(PendingPaymentView), findsNothing);
  });
}
