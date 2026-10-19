import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/app_strings.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/library/domain/entities/library_account.dart';
import 'package:univalle_app/features/library/library_strings.dart';
import 'package:univalle_app/features/library/presentation/providers/library_providers.dart';
import 'package:univalle_app/features/library/presentation/views/library_view.dart';
import 'package:univalle_app/features/library/presentation/widgets/library_loan_tile.dart';
import 'package:univalle_app/features/library/presentation/widgets/library_record_tile.dart';
import 'package:univalle_app/features/library/presentation/widgets/library_skeleton.dart';

import '../../../../helpers/pump_app.dart';
import '../library_fixtures.dart';

void main() {
  late MockLibraryRepository repository;

  setUp(() {
    repository = MockLibraryRepository();
  });

  Future<void> pumpView(WidgetTester tester) async {
    await tester.pumpApp(
      const LibraryView(),
      overrides: [libraryRepositoryProvider.overrideWithValue(repository)],
    );
  }

  void stubAccount(LibraryAccount value) {
    when(() => repository.getAccount()).thenAnswer((_) async => Ok(value));
  }

  testWidgets('shows a skeleton while loading', (tester) async {
    final completer = Completer<Result<LibraryAccount>>();
    when(() => repository.getAccount()).thenAnswer((_) => completer.future);

    await pumpView(tester);
    await tester.pump();

    expect(find.byType(LibrarySkeleton), findsOneWidget);
    completer.complete(Ok(account()));
    await tester.pumpAndSettle();
  });

  testWidgets('shows the fine and the current loans', (tester) async {
    stubAccount(account(currentFine: r'$3.000'));

    await pumpView(tester);
    await tester.pumpAndSettle();

    expect(find.text(LibraryStrings.currentFineLabel), findsOneWidget);
    expect(find.text(r'$3.000'), findsOneWidget);
    expect(find.byType(LibraryLoanTile), findsOneWidget);
  });

  testWidgets('shows the empty loans message', (tester) async {
    stubAccount(account(loans: []));

    await pumpView(tester);
    await tester.pumpAndSettle();

    expect(find.text(LibraryStrings.emptyLoans), findsOneWidget);
  });

  testWidgets('switches to the history tab', (tester) async {
    stubAccount(account(history: [record]));

    await pumpView(tester);
    await tester.pumpAndSettle();
    await tester.tap(find.text(LibraryStrings.historyTab));
    await tester.pumpAndSettle();

    expect(find.byType(LibraryRecordTile), findsOneWidget);
  });

  testWidgets('shows the empty history message', (tester) async {
    stubAccount(account());

    await pumpView(tester);
    await tester.pumpAndSettle();
    await tester.tap(find.text(LibraryStrings.historyTab));
    await tester.pumpAndSettle();

    expect(find.text(LibraryStrings.emptyHistory), findsOneWidget);
  });

  testWidgets('renewing a loan shows the new due date', (tester) async {
    stubAccount(account());
    when(() => repository.renewLoan('B1'))
        .thenAnswer((_) async => const Ok('2026-04-01'));

    await pumpView(tester);
    await tester.pumpAndSettle();
    await tester.tap(find.text(LibraryStrings.renewAction));
    await tester.pumpAndSettle();

    expect(
      find.text('${LibraryStrings.renewSuccess} 2026-04-01'),
      findsOneWidget,
    );
    expect(
      find.text('${LibraryStrings.dueDateLabel}: 2026-04-01'),
      findsOneWidget,
    );
  });

  testWidgets('a failed renewal shows the failure message', (tester) async {
    stubAccount(account());
    when(() => repository.renewLoan('B1')).thenAnswer(
      (_) async => Err(BusinessFailure(message: 'Límite de renovaciones')),
    );

    await pumpView(tester);
    await tester.pumpAndSettle();
    await tester.tap(find.text(LibraryStrings.renewAction));
    await tester.pumpAndSettle();

    expect(find.text('Límite de renovaciones'), findsOneWidget);
  });

  testWidgets('shows the failure and retries', (tester) async {
    when(() => repository.getAccount())
        .thenAnswer((_) async => Err(NetworkFailure(message: 'down')));
    await pumpView(tester);
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.networkError), findsOneWidget);

    stubAccount(account());
    await tester.tap(find.text(AppStrings.retry));
    await tester.pumpAndSettle();

    expect(find.byType(LibraryLoanTile), findsOneWidget);
  });
}
