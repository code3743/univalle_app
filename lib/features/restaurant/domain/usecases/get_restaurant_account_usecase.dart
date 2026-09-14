import '../../../../core/error/result.dart';
import '../entities/restaurant_account.dart';
import '../repositories/restaurant_repository.dart';

class GetRestaurantAccountUseCase {
  final RestaurantRepository _repository;
  const GetRestaurantAccountUseCase(this._repository);

  Future<Result<RestaurantAccount>> call() {
    return _repository.getAccount();
  }
}
