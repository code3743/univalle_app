import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/library/library_strings.dart';
import 'package:univalle_app/features/library/presentation/widgets/library_empty_state.dart';
import 'package:univalle_app/features/library/presentation/widgets/library_loan_tile.dart';
import 'package:univalle_app/features/library/presentation/widgets/library_record_tile.dart';
import 'package:univalle_app/features/library/presentation/widgets/library_tab_bar.dart';

import '../../../../helpers/pump_app.dart';
import '../library_fixtures.dart';

void main() {
  testWidgets('LibraryEmptyState shows the icon and message', (tester) async {
    await tester.pumpApp(
      const LibraryEmptyState(icon: Icons.menu_book_outlined, message: 'Vacío'),
    );

    expect(find.byIcon(Icons.menu_book_outlined), findsOneWidget);
    expect(find.text('Vacío'), findsOneWidget);
  });

  testWidgets('LibraryRecordTile shows the history entry', (tester) async {
    await tester.pumpApp(const LibraryRecordTile(record: record));

    expect(find.text('Álgebra lineal'), findsOneWidget);
    expect(find.text('Sala general'), findsOneWidget);
    expect(find.text('2025-10-10'), findsOneWidget);
  });

  testWidgets('LibraryTabBar labels both tabs', (tester) async {
    await tester.pumpApp(
      DefaultTabController(length: 2, child: const LibraryTabBar()),
    );

    expect(find.text(LibraryStrings.loansTab), findsOneWidget);
    expect(find.text(LibraryStrings.historyTab), findsOneWidget);
  });

  group('LibraryLoanTile', () {
    testWidgets('shows the loan and no fine when there is none', (
      tester,
    ) async {
      await tester.pumpApp(LibraryLoanTile(loan: loan(), onRenew: () async {}));

      expect(find.text('Cálculo de una variable'), findsOneWidget);
      expect(
        find.text('${LibraryStrings.dueDateLabel}: 2026-03-01'),
        findsOneWidget,
      );
      expect(find.textContaining(LibraryStrings.fineLabel), findsNothing);
    });

    testWidgets('shows the fine when the loan has one', (tester) async {
      await tester.pumpApp(
        LibraryLoanTile(
          loan: loan(fine: '1500'),
          onRenew: () async {},
        ),
      );

      expect(find.text(r'Multa: $1500'), findsOneWidget);
    });

    testWidgets('shows a spinner while renewing, then the button again', (
      tester,
    ) async {
      await tester.pumpApp(
        LibraryLoanTile(
          loan: loan(),
          onRenew: () async {
            await Future<void>.delayed(const Duration(milliseconds: 100));
          },
        ),
      );

      await tester.tap(find.text(LibraryStrings.renewAction));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(LibraryStrings.renewAction), findsNothing);

      await tester.pump(const Duration(milliseconds: 150));
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text(LibraryStrings.renewAction), findsOneWidget);
    });
  });
}
