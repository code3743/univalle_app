import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/app_strings.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/resolution/domain/entities/curriculum.dart';
import 'package:univalle_app/features/resolution/presentation/providers/resolution_providers.dart';
import 'package:univalle_app/features/resolution/presentation/views/resolution_view.dart';
import 'package:univalle_app/features/resolution/presentation/widgets/resolution_skeleton.dart';
import 'package:univalle_app/features/resolution/presentation/widgets/subject_card.dart';
import 'package:univalle_app/features/resolution/presentation/widgets/subject_detail_sheet.dart';
import 'package:univalle_app/features/resolution/resolution_strings.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/session.dart';
import '../resolution_fixtures.dart';

void main() {
  late MockResolutionRepository repository;

  setUp(() {
    repository = MockResolutionRepository();
  });

  Future<void> pumpView(WidgetTester tester) => tester.pumpApp(
    const ResolutionView(),
    overrides: [
      signedInAs(),
      resolutionRepositoryProvider.overrideWithValue(repository),
    ],
  );

  testWidgets('shows a skeleton while loading', (tester) async {
    final completer = Completer<Result<Curriculum>>();
    when(() => repository.getCurriculum(username: 'jdoe'))
        .thenAnswer((_) => completer.future);

    await pumpView(tester);
    await tester.pump();

    expect(find.byType(ResolutionSkeleton), findsOneWidget);
    completer.complete(Ok(curriculum()));
    await tester.pumpAndSettle();
  });

  testWidgets('shows the summary and one section per semester', (tester) async {
    when(() => repository.getCurriculum(username: 'jdoe'))
        .thenAnswer((_) async => Ok(curriculum()));

    await pumpView(tester);
    await tester.pumpAndSettle();

    expect(find.text(ResolutionStrings.semesterTitle(1)), findsOneWidget);
    expect(find.text(ResolutionStrings.semesterTitle(2)), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
    expect(find.text('Cálculo I'), findsOneWidget);
    expect(
      find.textContaining(ResolutionStrings.creditsValue(1)),
      findsWidgets,
    );
    expect(find.text(ResolutionStrings.prerequisitesChip(1)), findsOneWidget);
    expect(find.text(ResolutionStrings.prerequisitesChip(2)), findsOneWidget);
  });

  testWidgets('shows the empty message for an empty curriculum', (
    tester,
  ) async {
    when(() => repository.getCurriculum(username: 'jdoe'))
        .thenAnswer((_) async => Ok(Curriculum(subjects: const [])));

    await pumpView(tester);
    await tester.pumpAndSettle();

    expect(find.text(ResolutionStrings.empty), findsOneWidget);
  });

  testWidgets('shows the failure and retries', (tester) async {
    when(() => repository.getCurriculum(username: 'jdoe'))
        .thenAnswer((_) async => Err(NetworkFailure(message: 'down')));
    await pumpView(tester);
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.networkError), findsOneWidget);

    when(() => repository.getCurriculum(username: 'jdoe'))
        .thenAnswer((_) async => Ok(curriculum()));
    await tester.tap(find.text(AppStrings.retry));
    await tester.pumpAndSettle();

    expect(find.byType(SubjectCard), findsNWidgets(3));
  });

  testWidgets('opens a subject sheet and walks to a related subject', (
    tester,
  ) async {
    when(() => repository.getCurriculum(username: 'jdoe'))
        .thenAnswer((_) async => Ok(curriculum()));
    await pumpView(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(SubjectCard, 'Cálculo II'));
    await tester.pumpAndSettle();

    expect(find.byType(SubjectDetailSheet), findsOneWidget);
    expect(
      find.text(ResolutionStrings.prerequisitesSectionTitle),
      findsOneWidget,
    );
    expect(find.text(ResolutionStrings.unlocksSectionTitle), findsOneWidget);
    expect(find.text(ResolutionStrings.noUnlocks), findsNothing);

    final sheet = find.byType(SubjectDetailSheet);
    await tester.tap(
      find.descendant(of: sheet, matching: find.text('Cálculo I')),
    );
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(SubjectDetailSheet),
        matching: find.text(ResolutionStrings.noPrerequisites),
      ),
      findsOneWidget,
    );
    expect(find.byType(SubjectDetailSheet), findsOneWidget);
  });

  testWidgets('a subject nothing depends on shows the empty unlock message', (
    tester,
  ) async {
    when(() => repository.getCurriculum(username: 'jdoe'))
        .thenAnswer((_) async => Ok(curriculum()));
    await pumpView(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(SubjectCard, 'Electiva libre'));
    await tester.pumpAndSettle();

    expect(find.text(ResolutionStrings.noUnlocks), findsOneWidget);
    expect(find.byIcon(Icons.arrow_upward), findsNWidgets(2));
  });
}
