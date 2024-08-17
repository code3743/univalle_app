class PaymentProcess {
  final int numberLunch;
  final double total;
  final String startDate;
  final String expirationDate;
  final String message;
  final String paymentUrl;

  PaymentProcess({
    required this.numberLunch,
    required this.total,
    required this.startDate,
    required this.expirationDate,
    required this.message,
    required this.paymentUrl,
  });
}
