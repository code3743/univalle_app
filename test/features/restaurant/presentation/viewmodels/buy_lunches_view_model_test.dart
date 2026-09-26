import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/restaurant/domain/entities/lunch_payment.dart';
import 'package:univalle_app/features/restaurant/domain/repositories/restaurant_repository.dart';
import 'package:univalle_app/features/restaurant/presentation/providers/restaurant_providers.dart';
import 'package:univalle_app/features/restaurant/presentation/viewmodels/buy_lunches_view_model.dart';

import '../../../../helpers/container.dart';

class MockRestaurantRepository extends Mock implements RestaurantRepository {}

const _payment = LunchPayment(
  quantity: 3,
  total: 10500,
  purchaseDate: '2024-01-01',
  expirationDate: '2024-01-02',
  message: 'ok',
  paymentUrl: 'https://pay',
);

void main() {
  late MockRestaurantRepository repository;

  setUp(() {
    repository = MockRestaurantRepository();
  });

  List<Override> overridesWith(RestaurantRepository repo) => [
    restaurantRepositoryProvider.overrideWithValue(repo),
  ];

  test('build starts with no pending payment', () async {
    final container = createContainer(overrides: overridesWith(repository));

    final payment = await container.read(buyLunchesViewModelProvider.future);

    expect(payment, isNull);
  });

  test('submit resolves to the payment on success', () async {
    when(() => repository.buyLunches(quantity: 3, total: 10500))
        .thenAnswer((_) async => const Ok(_payment));
    final container = createContainer(overrides: overridesWith(repository));
    await container.read(buyLunchesViewModelProvider.future);

    await container
        .read(buyLunchesViewModelProvider.notifier)
        .submit(quantity: 3, total: 10500);

    expect(container.read(buyLunchesViewModelProvider).value, same(_payment));
  });

  test('submit sets an AsyncError when the repository fails', () async {
    when(
      () => repository.buyLunches(
        quantity: any(named: 'quantity'),
        total: any(named: 'total'),
      ),
    ).thenAnswer((_) async => Err(NetworkFailure(message: 'down')));
    final container = createContainer(overrides: overridesWith(repository));
    await container.read(buyLunchesViewModelProvider.future);

    await container
        .read(buyLunchesViewModelProvider.notifier)
        .submit(quantity: 3, total: 10500);

    expect(container.read(buyLunchesViewModelProvider), isA<AsyncError>());
  });
}
