import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/app_strings.dart';
import 'package:univalle_app/core/domain/entities/student.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/digital_card/digital_card_strings.dart';
import 'package:univalle_app/features/digital_card/presentation/views/digital_card_view.dart';
import 'package:univalle_app/features/digital_card/presentation/widgets/student_id_card/student_id_card.dart';
import 'package:univalle_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:univalle_app/features/profile/presentation/providers/profile_providers.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/session.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository repository;

  setUp(() {
    repository = MockProfileRepository();
  });

  List<Override> overrides() => [
    signedInAs('202012345'),
    profileRepositoryProvider.overrideWithValue(repository),
  ];

  Future<void> pumpView(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpApp(const DigitalCardView(), overrides: overrides());
  }

  testWidgets('shows a placeholder while the profile loads', (tester) async {
    final completer = Completer<Result<Student>>();
    when(() => repository.getStudent(username: '202012345'))
        .thenAnswer((_) => completer.future);

    await pumpView(tester);
    await tester.pump();

    expect(find.byType(StudentIdCard), findsNothing);
    completer.complete(Ok(fakeStudent()));
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('shows the card with the signed-in student code', (tester) async {
    when(() => repository.getStudent(username: '202012345'))
        .thenAnswer((_) async => Ok(fakeStudent()));

    await pumpView(tester);
    await tester.pump(const Duration(seconds: 1));

    expect(find.text(DigitalCardStrings.title), findsOneWidget);
    expect(find.byType(StudentIdCard), findsOneWidget);
    expect(find.text('202012345'), findsOneWidget);
  });

  testWidgets('shows the failure and retries', (tester) async {
    when(() => repository.getStudent(username: '202012345'))
        .thenAnswer((_) async => Err(NetworkFailure(message: 'down')));
    await pumpView(tester);
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.networkError), findsOneWidget);

    when(() => repository.getStudent(username: '202012345'))
        .thenAnswer((_) async => Ok(fakeStudent()));
    await tester.tap(find.text(AppStrings.retry));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(StudentIdCard), findsOneWidget);
  });
}
