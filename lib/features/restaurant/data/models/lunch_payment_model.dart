import '../../domain/entities/lunch_payment.dart';

class LunchPaymentModel {
  final int quantity;
  final double total;
  final String purchaseDate;
  final String expirationDate;
  final String message;
  final String paymentUrl;

  const LunchPaymentModel({
    required this.quantity,
    required this.total,
    required this.purchaseDate,
    required this.expirationDate,
    required this.message,
    required this.paymentUrl,
  });

  LunchPayment toEntity() => LunchPayment(
    quantity: quantity,
    total: total,
    purchaseDate: purchaseDate,
    expirationDate: expirationDate,
    message: message,
    paymentUrl: paymentUrl,
  );
}
