import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/restaurant/data/models/weekly_menu_model.dart';

void main() {
  test('maps a weekly menu with open and closed days to entities', () {
    const model = WeeklyMenuModel(
      weekLabel: 'Semana 1',
      days: [
        DailyMenuModel(
          dayLabel: 'LUNES',
          dishes: [MenuDishModel(category: 'Sopa', name: 'Crema')],
        ),
        DailyMenuModel(dayLabel: 'MARTES', closedReason: 'FESTIVO'),
      ],
    );

    final menu = model.toEntity();

    expect(menu.weekLabel, 'Semana 1');
    expect(menu.days, hasLength(2));
    expect(menu.days.first.isClosed, isFalse);
    expect(menu.days.first.dishes.single.category, 'Sopa');
    expect(menu.days.first.dishes.single.name, 'Crema');
    expect(menu.days.last.isClosed, isTrue);
    expect(menu.days.last.closedReason, 'FESTIVO');
    expect(menu.days.last.dishes, isEmpty);
  });
}
