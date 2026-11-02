import '../../../../core/error/result.dart';
import '../entities/weekly_menu.dart';

abstract interface class RestaurantMenuRepository {
  Future<Result<WeeklyMenu>> getWeeklyMenu();
}
