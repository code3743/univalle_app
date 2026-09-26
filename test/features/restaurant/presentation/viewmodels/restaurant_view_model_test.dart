import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/restaurant/domain/entities/restaurant_account.dart';
import 'package:univalle_app/features/restaurant/domain/repositories/restaurant_repository.dart';
import 'package:univalle_app/features/restaurant/presentation/providers/restaurant_providers.dart';
import 'package:univalle_app/features/restaurant/presentation/viewmodels/restaurant_view_model.dart';

import '../../../../helpers/container.dart';

class MockRestaurantRepository extends Mock implements RestaurantRepository {}

RestaurantAccount _account(int accumulatedLunches) => RestaurantAccount(
  membershipType: 'Estudiante',
  lunchPrice: 3500,
  accumulatedLunches: accumulatedLunches,
  minPurchase: 1,
  maxPurchase: 10,
);

void main() {
  late MockRestaurantRepository repository;

  setUp(() {
    repository = MockRestaurantRepository();
  });

  List<Override> overridesWith(RestaurantRepository repo) => [
    restaurantRepositoryProvider.overrideWithValue(repo),
  ];

  test('returns the account on success', () async {
    when(() => repository.getAccount())
        .thenAnswer((_) async => Ok(_account(2)));
    final container = createContainer(overrides: overridesWith(repository));

    final account = await container.read(restaurantViewModelProvider.future);

    expect(account.accumulatedLunches, 2);
  });

  test('throws the failure when the repository call fails', () async {
    final failure = NetworkFailure(message: 'down');
    when(() => repository.getAccount()).thenAnswer((_) async => Err(failure));
    final container = createContainer(overrides: overridesWith(repository));

    await expectLater(
      container.read(restaurantViewModelProvider.future),
      throwsA(same(failure)),
    );
  });

  group('confirmPayment', () {
    test(
      'reports confirmed and updates state when lunches increased',
      () async {
        when(() => repository.getAccount())
            .thenAnswer((_) async => Ok(_account(2)));
        final container = createContainer(overrides: overridesWith(repository));
        await container.read(restaurantViewModelProvider.future);
        when(() => repository.getAccount())
            .thenAnswer((_) async => Ok(_account(4)));

        final outcome = await container
            .read(restaurantViewModelProvider.notifier)
            .confirmPayment();

        expect(outcome, PaymentConfirmationResult.confirmed);
        expect(
          container.read(restaurantViewModelProvider).value!.accumulatedLunches,
          4,
        );
      },
    );

    test('reports stillPending when the count has not changed', () async {
      when(() => repository.getAccount())
          .thenAnswer((_) async => Ok(_account(2)));
      final container = createContainer(overrides: overridesWith(repository));
      await container.read(restaurantViewModelProvider.future);

      final outcome = await container
          .read(restaurantViewModelProvider.notifier)
          .confirmPayment();

      expect(outcome, PaymentConfirmationResult.stillPending);
    });

    test(
      'throws the failure without touching state when the call fails',
      () async {
        when(() => repository.getAccount())
            .thenAnswer((_) async => Ok(_account(2)));
        final container = createContainer(overrides: overridesWith(repository));
        await container.read(restaurantViewModelProvider.future);
        final failure = NetworkFailure(message: 'down');
        when(() => repository.getAccount())
            .thenAnswer((_) async => Err(failure));

        await expectLater(
          container.read(restaurantViewModelProvider.notifier).confirmPayment(),
          throwsA(same(failure)),
        );
        expect(
          container.read(restaurantViewModelProvider).value!.accumulatedLunches,
          2,
        );
      },
    );
  });
}
