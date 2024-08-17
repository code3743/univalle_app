import 'package:univalle_app/features/restaurant/domain/entities/payment_process.dart';

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
