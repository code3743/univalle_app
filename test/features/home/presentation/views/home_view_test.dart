import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:univalle_app/core/constants/app_strings.dart';
import 'package:univalle_app/core/device/app_platform_provider.dart';
import 'package:univalle_app/core/domain/entities/student.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/core/router/app_routes.dart';
import 'package:univalle_app/core/widgets/user_avatar.dart';
import 'package:univalle_app/features/home/home_strings.dart';
import 'package:univalle_app/features/home/presentation/views/all_shortcuts_view.dart';
import 'package:univalle_app/features/home/presentation/views/home_view.dart';
import 'package:univalle_app/features/home/presentation/widgets/home_skeleton.dart';
import 'package:univalle_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:univalle_app/features/profile/presentation/providers/profile_providers.dart';
import 'package:univalle_app/features/remote_config/presentation/providers/remote_config_providers.dart';
import 'package:univalle_app/features/student_grades/presentation/providers/grades_providers.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/session.dart';
import '../../../remote_config/presentation/remote_config_fixtures.dart';
import '../../../student_grades/presentation/grades_fixtures.dart' as grades;

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository profileRepository;
  late MockRemoteConfigRepository configRepository;
  late grades.MockGradesRepository gradesRepository;

  setUp(() {
    profileRepository = MockProfileRepository();
    configRepository = MockRemoteConfigRepository();
    gradesRepository = grades.MockGradesRepository();
    PackageInfo.setMockInitialValues(
      appName: 'Univalle',
      packageName: 'co.edu.univalle',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
    when(() => profileRepository.getStudent(username: 'jdoe'))
        .thenAnswer((_) async => Ok(fakeStudent()));
    when(
      () => configRepository.getConfig(
        platform: any(named: 'platform'),
        version: any(named: 'version'),
      ),
    ).thenAnswer(
      (_) async => Ok(
        fakeAppConfig(
          modules: [fakeAppModule(label: 'Notas')],
          quickAccess: ['grades'],
        ),
      ),
    );
    when(() => configRepository.getDismissedUpdate())
        .thenAnswer((_) async => const Ok(null));
    when(() => configRepository.getSeenWelcome())
        .thenAnswer((_) async => const Ok(null));
    when(() => gradesRepository.getGrades(username: 'jdoe')).thenAnswer(
      (_) async => Ok(
        grades.history(
          periods: [grades.period(period: 'AGOSTO/2025 - DICIEMBRE/2025')],
        ),
      ),
    );
  });

  List<Override> overrides() => [
    signedInAs(),
    profileRepositoryProvider.overrideWithValue(profileRepository),
    remoteConfigRepositoryProvider.overrideWithValue(configRepository),
    gradesRepositoryProvider.overrideWithValue(gradesRepository),
    appPlatformProvider.overrideWithValue('android'),
  ];

  group('HomeView', () {
    Future<void> pumpHome(WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpRoutedApp(const HomeView(), overrides: overrides());
      await tester.pumpAndSettle();
    }

    testWidgets('greets the student and shows their program and stats', (
      tester,
    ) async {
      await pumpHome(tester);

      expect(find.text('Juan 👋'), findsOneWidget);
      expect(find.text('Ingeniería de Sistemas'), findsOneWidget);
      expect(find.text('4.1'), findsOneWidget);
      expect(find.text('120'), findsOneWidget);
      expect(find.text('Notas'), findsOneWidget);
      expect(
        find.text('${HomeStrings.currentSemesterLabel} 2025-2'),
        findsOneWidget,
      );
    });

    testWidgets('shows a skeleton while the profile loads', (tester) async {
      final completer = Completer<Result<Student>>();
      when(() => profileRepository.getStudent(username: 'jdoe'))
          .thenAnswer((_) => completer.future);
      await tester.pumpRoutedApp(const HomeView(), overrides: overrides());

      expect(find.byType(HomeSkeleton), findsOneWidget);
      completer.complete(Ok(fakeStudent()));
      await tester.pumpAndSettle();
    });

    testWidgets('shows the failure and retries', (tester) async {
      when(() => profileRepository.getStudent(username: 'jdoe'))
          .thenAnswer((_) async => Err(NetworkFailure(message: 'down')));
      await pumpHome(tester);
      expect(find.text(AppStrings.networkError), findsOneWidget);

      when(() => profileRepository.getStudent(username: 'jdoe'))
          .thenAnswer((_) async => Ok(fakeStudent()));
      await tester.tap(find.text(AppStrings.retry));
      await tester.pumpAndSettle();

      expect(find.text('Juan 👋'), findsOneWidget);
    });

    testWidgets('the avatar and the program card open the profile', (
      tester,
    ) async {
      await pumpHome(tester);

      await tester.tap(find.byType(UserAvatar));
      await tester.pumpAndSettle();

      expect(find.text('route:${AppRoutes.profile}'), findsOneWidget);
    });

    testWidgets('the bell opens the announcements', (tester) async {
      await pumpHome(tester);

      await tester.tap(find.byIcon(Icons.notifications_none));
      await tester.pumpAndSettle();

      expect(find.text('route:${AppRoutes.announcements}'), findsOneWidget);
    });

    testWidgets('"view all" opens every functionality', (tester) async {
      await pumpHome(tester);

      await tester.tap(find.text(HomeStrings.viewAll));
      await tester.pumpAndSettle();

      expect(
        find.text('route:${AppRoutes.allFunctionalities}'),
        findsOneWidget,
      );
    });

    testWidgets('shows a placeholder semester without grades', (tester) async {
      when(() => gradesRepository.getGrades(username: 'jdoe'))
          .thenAnswer((_) async => Ok(grades.history(periods: [])));
      await pumpHome(tester);

      expect(
        find.text(
          '${HomeStrings.currentSemesterLabel} ${HomeStrings.currentSemesterUnknown}',
        ),
        findsOneWidget,
      );
    });
  });

  group('AllShortcutsView', () {
    testWidgets('lists every module, including disabled ones', (tester) async {
      when(
        () => configRepository.getConfig(
          platform: any(named: 'platform'),
          version: any(named: 'version'),
        ),
      ).thenAnswer(
        (_) async => Ok(
          fakeAppConfig(
            modules: [
              fakeAppModule(label: 'Notas'),
              fakeAppModule(key: 'x', label: 'Apagado', disabled: true),
            ],
          ),
        ),
      );
      await tester.pumpRoutedApp(
        const AllShortcutsView(),
        overrides: overrides(),
      );
      await tester.pumpAndSettle();

      expect(find.text(HomeStrings.allFunctionalitiesTitle), findsOneWidget);
      expect(find.text('Notas'), findsOneWidget);
      expect(find.text('Apagado'), findsOneWidget);

      await tester.tap(find.text('Notas'));
      await tester.pumpAndSettle();

      expect(find.text('route:${AppRoutes.grades}'), findsOneWidget);
    });

    testWidgets('offers a retry when the config is unavailable', (
      tester,
    ) async {
      when(
        () => configRepository.getConfig(
          platform: any(named: 'platform'),
          version: any(named: 'version'),
        ),
      ).thenAnswer((_) async => Err(NetworkFailure(message: 'down')));
      await tester.pumpRoutedApp(
        const AllShortcutsView(),
        overrides: overrides(),
      );
      await tester.pumpAndSettle();

      expect(find.text(HomeStrings.modulesUnavailableTitle), findsOneWidget);
    });
  });
}
