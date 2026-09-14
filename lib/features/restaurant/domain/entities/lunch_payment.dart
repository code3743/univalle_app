class LunchPayment {
  final int quantity;
  final double total;
  final String purchaseDate;
  final String expirationDate;
  final String message;
  final String paymentUrl;

  const LunchPayment({
    required this.quantity,
    required this.total,
    required this.purchaseDate,
    required this.expirationDate,
    required this.message,
    required this.paymentUrl,
  });
}
