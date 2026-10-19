import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/restaurant/presentation/utils/lunch_money_formatter.dart';

void main() {
  test('formats pesos with thousands separators and no decimals', () {
    expect(LunchMoneyFormatter.format(3500), contains('3.500'));
    expect(LunchMoneyFormatter.format(10500.4), contains('10.500'));
    expect(LunchMoneyFormatter.format(3500), contains(r'$'));
  });
}
