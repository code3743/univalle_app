import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/restaurant/data/models/lunch_payment_model.dart';
import 'package:univalle_app/features/restaurant/data/models/restaurant_account_model.dart';

void main() {
  test('toEntity maps a null pendingPayment as null', () {
    const model = RestaurantAccountModel(
      membershipType: 'Regular',
      lunchPrice: 5000,
      accumulatedLunches: 3,
      minPurchase: 1,
      maxPurchase: 10,
    );

    expect(model.toEntity().pendingPayment, isNull);
  });

  test('toEntity maps a present pendingPayment', () {
    const model = RestaurantAccountModel(
      membershipType: 'Regular',
      lunchPrice: 5000,
      accumulatedLunches: 3,
      minPurchase: 1,
      maxPurchase: 10,
      pendingPayment: LunchPaymentModel(
        quantity: 5,
        total: 25000,
        purchaseDate: '2026-03-05',
        expirationDate: '2026-04-05',
        message: 'Pendiente',
        paymentUrl: 'https://pagos.univalle.edu.co/x',
      ),
    );

    final entity = model.toEntity();

    expect(entity.membershipType, 'Regular');
    expect(entity.lunchPrice, 5000);
    expect(entity.accumulatedLunches, 3);
    expect(entity.minPurchase, 1);
    expect(entity.maxPurchase, 10);
    expect(entity.pendingPayment?.quantity, 5);
    expect(
      entity.pendingPayment?.paymentUrl,
      'https://pagos.univalle.edu.co/x',
    );
  });
}
