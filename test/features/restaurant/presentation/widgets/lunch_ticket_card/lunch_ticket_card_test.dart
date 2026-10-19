import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/restaurant/presentation/utils/lunch_money_formatter.dart';
import 'package:univalle_app/features/restaurant/presentation/widgets/lunch_ticket_card/lunch_ticket_card.dart';
import 'package:univalle_app/features/restaurant/restaurant_strings.dart';

import '../../../../../helpers/pump_app.dart';
import '../../restaurant_fixtures.dart';

void main() {
  testWidgets('shows the lunch count, membership and price', (tester) async {
    await tester.pumpApp(
      SingleChildScrollView(
        child: LunchTicketCard(account: account(accumulatedLunches: 4)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('4'), findsOneWidget);
    expect(find.text(RestaurantStrings.accumulatedLunches), findsOneWidget);
    expect(find.text('Estudiante'), findsOneWidget);
    expect(find.text(LunchMoneyFormatter.format(3500)), findsOneWidget);
  });
}
