import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/core/storage/auth_local_datasource.dart';
import 'package:univalle_app/features/restaurant/data/datasources/restaurant_remote_datasource.dart';
import 'package:univalle_app/features/restaurant/data/models/lunch_payment_model.dart';
import 'package:univalle_app/features/restaurant/data/models/restaurant_account_model.dart';
import 'package:univalle_app/features/restaurant/data/repositories/restaurant_repository_impl.dart';
import 'package:univalle_app/features/restaurant/domain/entities/lunch_payment.dart';
import 'package:univalle_app/features/restaurant/domain/entities/restaurant_account.dart';

class MockRestaurantRemoteDataSource extends Mock
    implements RestaurantRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late MockRestaurantRemoteDataSource remote;
  late MockAuthLocalDataSource credentials;
  late RestaurantRepositoryImpl repository;

  setUp(() {
    remote = MockRestaurantRemoteDataSource();
    credentials = MockAuthLocalDataSource();
    repository = RestaurantRepositoryImpl(remote, credentials);
  });

  group('getAccount', () {
    test(
      'returns the account mapped to an entity when credentials exist',
      () async {
        when(() => credentials.getCredentials()).thenAnswer(
          (_) async =>
              const StoredCredentials(username: 'jperez', password: 'x'),
        );
        when(() => remote.fetchAccount(username: 'jperez', password: 'x'))
            .thenAnswer(
              (_) async => const RestaurantAccountModel(
                membershipType: 'Regular',
                lunchPrice: 5000,
                accumulatedLunches: 3,
                minPurchase: 1,
                maxPurchase: 10,
              ),
            );

        final result = await repository.getAccount();

        expect(result, isA<Ok<RestaurantAccount>>());
        expect(
          (result as Ok<RestaurantAccount>).value.membershipType,
          'Regular',
        );
      },
    );

    test(
      'returns an AuthFailure when there are no saved credentials',
      () async {
        when(() => credentials.getCredentials()).thenAnswer((_) async => null);

        final result = await repository.getAccount();

        expect((result as Err<RestaurantAccount>).failure, isA<AuthFailure>());
        verifyNever(
          () => remote.fetchAccount(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        );
      },
    );

    test('maps a thrown AppException to a Failure', () async {
      when(() => credentials.getCredentials()).thenAnswer(
        (_) async => const StoredCredentials(username: 'jperez', password: 'x'),
      );
      when(() => remote.fetchAccount(username: 'jperez', password: 'x'))
          .thenThrow(const ServerException(message: 'boom', statusCode: 500));

      final result = await repository.getAccount();

      expect((result as Err<RestaurantAccount>).failure, isA<ServerFailure>());
    });
  });

  group('buyLunches', () {
    test(
      'returns the payment mapped to an entity, without requiring credentials',
      () async {
        when(() => remote.buyLunches(quantity: 5, total: 25000)).thenAnswer(
          (_) async => const LunchPaymentModel(
            quantity: 5,
            total: 25000,
            purchaseDate: '2026-03-05',
            expirationDate: '2026-04-05',
            message: 'Pago exitoso',
            paymentUrl: 'https://pagos.univalle.edu.co/x',
          ),
        );

        final result = await repository.buyLunches(quantity: 5, total: 25000);

        expect(result, isA<Ok<LunchPayment>>());
        expect((result as Ok<LunchPayment>).value.quantity, 5);
        verifyNever(() => credentials.getCredentials());
      },
    );

    test('maps a thrown AppException to a Failure', () async {
      when(() => remote.buyLunches(quantity: 5, total: 25000))
          .thenThrow(const ServerException(message: 'boom', statusCode: 500));

      final result = await repository.buyLunches(quantity: 5, total: 25000);

      expect((result as Err<LunchPayment>).failure, isA<ServerFailure>());
    });
  });
}
