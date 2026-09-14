import '../../../../core/error/result.dart';
import '../entities/lunch_payment.dart';
import '../repositories/restaurant_repository.dart';

class BuyLunchesUseCase {
  final RestaurantRepository _repository;
  const BuyLunchesUseCase(this._repository);

  Future<Result<LunchPayment>> call({
    required int quantity,
    required double total,
  }) {
    return _repository.buyLunches(quantity: quantity, total: total);
  }
}
