import '../../domain/entities/restaurant_account.dart';
import 'lunch_payment_model.dart';

class RestaurantAccountModel {
  final String membershipType;
  final double lunchPrice;
  final int accumulatedLunches;
  final int minPurchase;
  final int maxPurchase;
  final LunchPaymentModel? pendingPayment;

  const RestaurantAccountModel({
    required this.membershipType,
    required this.lunchPrice,
    required this.accumulatedLunches,
    required this.minPurchase,
    required this.maxPurchase,
    this.pendingPayment,
  });

  RestaurantAccount toEntity() => RestaurantAccount(
    membershipType: membershipType,
    lunchPrice: lunchPrice,
    accumulatedLunches: accumulatedLunches,
    minPurchase: minPurchase,
    maxPurchase: maxPurchase,
    pendingPayment: pendingPayment?.toEntity(),
  );
}
