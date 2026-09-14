import '../../../../core/error/result.dart';
import '../entities/lunch_payment.dart';
import '../entities/restaurant_account.dart';

abstract interface class RestaurantRepository {
  Future<Result<RestaurantAccount>> getAccount();

  Future<Result<LunchPayment>> buyLunches({
    required int quantity,
    required double total,
  });
}
