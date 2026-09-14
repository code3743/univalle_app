import 'lunch_payment.dart';

class RestaurantAccount {
  final String membershipType;
  final double lunchPrice;
  final int accumulatedLunches;
  final int minPurchase;
  final int maxPurchase;
  final LunchPayment? pendingPayment;

  const RestaurantAccount({
    required this.membershipType,
    required this.lunchPrice,
    required this.accumulatedLunches,
    required this.minPurchase,
    required this.maxPurchase,
    this.pendingPayment,
  });
}
