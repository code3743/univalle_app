import '../../../../core/error/result.dart';
import '../entities/weekly_menu.dart';
import '../repositories/restaurant_menu_repository.dart';

class GetWeeklyMenuUseCase {
  final RestaurantMenuRepository _repository;
  const GetWeeklyMenuUseCase(this._repository);

  Future<Result<WeeklyMenu>> call() {
    return _repository.getWeeklyMenu();
  }
}
