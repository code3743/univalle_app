import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/restaurant/data/models/lunch_payment_model.dart';

void main() {
  test('toEntity maps every field', () {
    const model = LunchPaymentModel(
      quantity: 5,
      total: 25000,
      purchaseDate: '2026-03-05',
      expirationDate: '2026-04-05',
      message: 'Pago exitoso',
      paymentUrl: 'https://pagos.univalle.edu.co/x',
    );

    final entity = model.toEntity();

    expect(entity.quantity, 5);
    expect(entity.total, 25000);
    expect(entity.purchaseDate, '2026-03-05');
    expect(entity.expirationDate, '2026-04-05');
    expect(entity.message, 'Pago exitoso');
    expect(entity.paymentUrl, 'https://pagos.univalle.edu.co/x');
  });
}
