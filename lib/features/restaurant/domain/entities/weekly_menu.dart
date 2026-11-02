class MenuDish {
  final String category;
  final String name;

  const MenuDish({required this.category, required this.name});
}

class DailyMenu {
  final String dayLabel;
  final List<MenuDish> dishes;

  /// Set instead of [dishes] when the restaurant doesn't serve that day
  /// (e.g. "FESTIVO").
  final String? closedReason;

  const DailyMenu({
    required this.dayLabel,
    this.dishes = const [],
    this.closedReason,
  });

  bool get isClosed => closedReason != null;
}

class WeeklyMenu {
  final String weekLabel;
  final List<DailyMenu> days;

  const WeeklyMenu({required this.weekLabel, required this.days});
}
