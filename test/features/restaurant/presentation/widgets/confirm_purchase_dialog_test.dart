import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/restaurant/presentation/utils/lunch_money_formatter.dart';
import 'package:univalle_app/features/restaurant/presentation/widgets/confirm_purchase_dialog.dart';
import 'package:univalle_app/features/restaurant/restaurant_strings.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  Future<void> openDialog(
    WidgetTester tester,
    void Function(bool) onResult,
  ) async {
    await tester.pumpApp(
      Builder(
        builder: (context) => TextButton(
          onPressed: () async =>
              onResult(await ConfirmPurchaseDialog.show(context, total: 7000)),
          child: const Text('open'),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('shows the total and resolves true on confirm', (tester) async {
    bool? result;
    await openDialog(tester, (value) => result = value);

    expect(find.text(RestaurantStrings.confirmPurchaseTitle), findsOneWidget);
    expect(
      find.textContaining(LunchMoneyFormatter.format(7000)),
      findsOneWidget,
    );

    await tester.tap(find.text(RestaurantStrings.confirmLabel));
    await tester.pumpAndSettle();

    expect(result, isTrue);
  });

  testWidgets('resolves false on cancel', (tester) async {
    bool? result;
    await openDialog(tester, (value) => result = value);

    await tester.tap(find.text(RestaurantStrings.cancelLabel));
    await tester.pumpAndSettle();

    expect(result, isFalse);
  });

  testWidgets('resolves false when dismissed outside', (tester) async {
    bool? result;
    await openDialog(tester, (value) => result = value);

    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();

    expect(result, isFalse);
  });
}
