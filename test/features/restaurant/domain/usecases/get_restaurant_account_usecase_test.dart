import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/restaurant/domain/entities/restaurant_account.dart';
import 'package:univalle_app/features/restaurant/domain/repositories/restaurant_repository.dart';
import 'package:univalle_app/features/restaurant/domain/usecases/get_restaurant_account_usecase.dart';

class MockRestaurantRepository extends Mock implements RestaurantRepository {}

void main() {
  late MockRestaurantRepository repository;
  late GetRestaurantAccountUseCase useCase;

  setUp(() {
    repository = MockRestaurantRepository();
    useCase = GetRestaurantAccountUseCase(repository);
  });

  test('returns the account from the repository', () async {
    const account = RestaurantAccount(
      membershipType: 'Regular',
      lunchPrice: 5000,
      accumulatedLunches: 3,
      minPurchase: 1,
      maxPurchase: 10,
    );
    when(() => repository.getAccount())
        .thenAnswer((_) async => const Ok(account));

    final result = await useCase.call();

    expect((result as Ok<RestaurantAccount>).value, account);
    verify(() => repository.getAccount()).called(1);
  });

  test('propagates a failure result unchanged', () async {
    final failure = UnknownFailure(message: 'boom');
    when(() => repository.getAccount()).thenAnswer((_) async => Err(failure));

    final result = await useCase.call();

    expect((result as Err<RestaurantAccount>).failure, failure);
  });
}
