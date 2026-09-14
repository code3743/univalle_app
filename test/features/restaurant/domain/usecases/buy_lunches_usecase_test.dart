import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/restaurant/domain/entities/lunch_payment.dart';
import 'package:univalle_app/features/restaurant/domain/repositories/restaurant_repository.dart';
import 'package:univalle_app/features/restaurant/domain/usecases/buy_lunches_usecase.dart';

class MockRestaurantRepository extends Mock implements RestaurantRepository {}

void main() {
  late MockRestaurantRepository repository;
  late BuyLunchesUseCase useCase;

  setUp(() {
    repository = MockRestaurantRepository();
    useCase = BuyLunchesUseCase(repository);
  });

  test('forwards quantity and total to the repository', () async {
    const payment = LunchPayment(
      quantity: 5,
      total: 25000,
      purchaseDate: '2026-03-05',
      expirationDate: '2026-04-05',
      message: 'Pago exitoso',
      paymentUrl: 'https://pagos.univalle.edu.co/x',
    );
    when(() => repository.buyLunches(quantity: 5, total: 25000))
        .thenAnswer((_) async => const Ok(payment));

    final result = await useCase.call(quantity: 5, total: 25000);

    expect((result as Ok<LunchPayment>).value, payment);
    verify(() => repository.buyLunches(quantity: 5, total: 25000)).called(1);
  });

  test('propagates a failure result unchanged', () async {
    final failure = UnknownFailure(message: 'boom');
    when(() => repository.buyLunches(quantity: 5, total: 25000))
        .thenAnswer((_) async => Err(failure));

    final result = await useCase.call(quantity: 5, total: 25000);

    expect((result as Err<LunchPayment>).failure, failure);
  });
}
