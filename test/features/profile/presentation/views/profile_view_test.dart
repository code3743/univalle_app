import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/app_strings.dart';
import 'package:univalle_app/core/domain/entities/student.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/core/session/current_username_provider.dart';
import 'package:univalle_app/features/auth/domain/entities/auth_session.dart';
import 'package:univalle_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:univalle_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:univalle_app/features/profile/presentation/providers/profile_providers.dart';
import 'package:univalle_app/features/profile/presentation/views/profile_view.dart';
import 'package:univalle_app/features/profile/presentation/widgets/profile_skeleton.dart';
import 'package:univalle_app/features/profile/profile_strings.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/pump_app.dart';
import '../../../auth/presentation/auth_fixtures.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository repository;
  late MockAuthRepository authRepository;

  setUp(() {
    repository = MockProfileRepository();
    authRepository = MockAuthRepository();
    when(() => authRepository.restoreSession())
        .thenAnswer((_) async => const Ok(AuthSession(username: 'jdoe')));
  });

  List<Override> overrides() => [
    profileRepositoryProvider.overrideWithValue(repository),
    authRepositoryProvider.overrideWithValue(authRepository),
  ];

  Future<void> pumpView(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpApp(const ProfileView(), overrides: overrides());
    final container = ProviderScope.containerOf(
      tester.element(find.byType(ProfileView)),
    );
    container.read(currentUsernameProvider.notifier).set('jdoe');
    await tester.pump();
  }

  testWidgets('shows a skeleton while the profile loads', (tester) async {
    final completer = Completer<Result<Student>>();
    when(() => repository.getStudent(username: 'jdoe'))
        .thenAnswer((_) => completer.future);

    await pumpView(tester);
    await tester.pump();

    expect(find.byType(ProfileSkeleton), findsOneWidget);
    completer.complete(Ok(fakeStudent()));
    await tester.pumpAndSettle();
  });

  testWidgets('shows every profile field', (tester) async {
    when(() => repository.getStudent(username: 'jdoe'))
        .thenAnswer((_) async => Ok(fakeStudent()));

    await pumpView(tester);
    await tester.pumpAndSettle();

    expect(find.text(ProfileStrings.title), findsOneWidget);
    expect(find.text('J'), findsOneWidget);
    expect(find.text('Juan Pérez'), findsOneWidget);
    expect(find.text('juan.perez@correounivalle.edu.co'), findsOneWidget);
    expect(find.text('1234567'), findsOneWidget);
    expect(find.text('Ingeniería de Sistemas'), findsOneWidget);
    expect(find.text('Meléndez'), findsOneWidget);
  });

  testWidgets('logging out calls the auth repository', (tester) async {
    when(() => repository.getStudent(username: 'jdoe'))
        .thenAnswer((_) async => Ok(fakeStudent()));
    when(() => authRepository.logout()).thenAnswer((_) async => const Ok(null));
    await pumpView(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.text(ProfileStrings.logout));
    await tester.pumpAndSettle();

    verify(() => authRepository.logout()).called(1);
  });

  testWidgets('shows the failure and retries', (tester) async {
    when(() => repository.getStudent(username: 'jdoe'))
        .thenAnswer((_) async => Err(NetworkFailure(message: 'down')));
    await pumpView(tester);
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.networkError), findsOneWidget);

    when(() => repository.getStudent(username: 'jdoe'))
        .thenAnswer((_) async => Ok(fakeStudent()));
    await tester.tap(find.text(AppStrings.retry));
    await tester.pumpAndSettle();

    expect(find.text('Juan Pérez'), findsOneWidget);
  });
}
