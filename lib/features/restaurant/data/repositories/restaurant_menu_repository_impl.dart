import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/weekly_menu.dart';
import '../../domain/repositories/restaurant_menu_repository.dart';
import '../datasources/restaurant_menu_remote_datasource.dart';

class RestaurantMenuRepositoryImpl implements RestaurantMenuRepository {
  final RestaurantMenuRemoteDataSource _remote;
  const RestaurantMenuRepositoryImpl(this._remote);

  @override
  Future<Result<WeeklyMenu>> getWeeklyMenu() async {
    try {
      final menu = await _remote.fetchWeeklyMenu();
      return Ok(menu.toEntity());
    } on AppException catch (e) {
      return Err(mapExceptionToFailure(e));
    }
  }
}
