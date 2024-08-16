class StudentRestaurant {
  final double priceLunch;
  final int numberLunch;
  final String typeLink;
  final int minNumberLunch;
  final int maxNumberLunch;
  final PaymentProcess? paymentProcess;
  StudentRestaurant({
    required this.priceLunch,
    required this.numberLunch,
    required this.typeLink,
    required this.minNumberLunch,
    required this.maxNumberLunch,
    this.paymentProcess,
  });
}

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
