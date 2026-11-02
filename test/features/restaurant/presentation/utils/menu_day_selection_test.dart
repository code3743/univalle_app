import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/restaurant/domain/entities/weekly_menu.dart';
import 'package:univalle_app/features/restaurant/presentation/utils/menu_day_selection.dart';

void main() {
  const days = [
    DailyMenu(dayLabel: 'Lunes 02', closedReason: 'FESTIVO'),
    DailyMenu(dayLabel: 'Martes 03'),
    DailyMenu(dayLabel: 'Miércoles 04'),
  ];

  test('selects today when the week lists it', () {
    expect(initialMenuDayIndex(days, DateTime(2026, 11, 4)), 2);
  });

  test('selects the next served day when today is not listed', () {
    expect(initialMenuDayIndex(days, DateTime(2026, 11, 1)), 1);
  });

  test('falls back to the first day when the week is over', () {
    expect(initialMenuDayIndex(days, DateTime(2026, 11, 20)), 0);
  });
}
