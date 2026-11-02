import '../../domain/entities/weekly_menu.dart';

class MenuDishModel {
  final String category;
  final String name;

  const MenuDishModel({required this.category, required this.name});

  MenuDish toEntity() => MenuDish(category: category, name: name);
}

class DailyMenuModel {
  final String dayLabel;
  final List<MenuDishModel> dishes;
  final String? closedReason;

  const DailyMenuModel({
    required this.dayLabel,
    this.dishes = const [],
    this.closedReason,
  });

  DailyMenu toEntity() => DailyMenu(
    dayLabel: dayLabel,
    dishes: dishes.map((dish) => dish.toEntity()).toList(),
    closedReason: closedReason,
  );
}

class WeeklyMenuModel {
  final String weekLabel;
  final List<DailyMenuModel> days;

  const WeeklyMenuModel({required this.weekLabel, required this.days});

  WeeklyMenu toEntity() => WeeklyMenu(
    weekLabel: weekLabel,
    days: days.map((day) => day.toEntity()).toList(),
  );
}
