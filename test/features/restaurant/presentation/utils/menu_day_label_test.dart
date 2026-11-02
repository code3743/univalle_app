import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/restaurant/presentation/utils/menu_day_label.dart';

void main() {
  test('splits a day label into short weekday and number', () {
    expect(splitMenuDayLabel('Miércoles 04'), (weekday: 'Mié', number: '04'));
  });

  test('keeps a label without a number as the weekday', () {
    expect(splitMenuDayLabel('Hoy'), (weekday: 'Hoy', number: ''));
  });
}
