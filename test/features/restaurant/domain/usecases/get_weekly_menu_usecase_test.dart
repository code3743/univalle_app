import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/restaurant/domain/entities/weekly_menu.dart';
import 'package:univalle_app/features/restaurant/domain/repositories/restaurant_menu_repository.dart';
import 'package:univalle_app/features/restaurant/domain/usecases/get_weekly_menu_usecase.dart';

class MockRestaurantMenuRepository extends Mock
    implements RestaurantMenuRepository {}

void main() {
  test('returns the weekly menu from the repository', () async {
    final repository = MockRestaurantMenuRepository();
    const menu = WeeklyMenu(weekLabel: 'Semana 1', days: []);
    when(() => repository.getWeeklyMenu())
        .thenAnswer((_) async => const Ok(menu));

    final result = await GetWeeklyMenuUseCase(repository)();

    expect((result as Ok<WeeklyMenu>).value, menu);
  });
}
