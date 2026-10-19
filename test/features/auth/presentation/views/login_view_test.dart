import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/app_strings.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/core/router/app_routes.dart';
import 'package:univalle_app/core/session/current_username_provider.dart';
import 'package:univalle_app/features/auth/auth_strings.dart';
import 'package:univalle_app/features/auth/domain/entities/auth_session.dart';
import 'package:univalle_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:univalle_app/features/auth/presentation/views/login_view.dart';

import '../../../../helpers/pump_app.dart';
import '../auth_fixtures.dart';

void main() {
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    when(() => repository.restoreSession())
        .thenAnswer((_) async => const Ok(null));
  });

  Future<void> pumpView(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpRoutedApp(
      const LoginView(),
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    await tester.pumpAndSettle();
  }

  Finder field(String label) => find.widgetWithText(TextFormField, label);

  testWidgets('shows the title and both fields', (tester) async {
    await pumpView(tester);

    expect(find.text(AuthStrings.title), findsOneWidget);
    expect(find.text(AuthStrings.subtitle), findsOneWidget);
    expect(field(AuthStrings.usernameLabel), findsOneWidget);
    expect(field(AuthStrings.passwordLabel), findsOneWidget);
  });

  testWidgets('requires a username and a password', (tester) async {
    await pumpView(tester);

    await tester.tap(find.text(AuthStrings.submit));
    await tester.pump();

    expect(find.text(AuthStrings.usernameRequired), findsOneWidget);
    expect(find.text(AuthStrings.passwordRequired), findsOneWidget);
    verifyNever(
      () => repository.login(
        username: any(named: 'username'),
        password: any(named: 'password'),
      ),
    );
  });

  testWidgets('toggles password visibility', (tester) async {
    await pumpView(tester);
    TextField passwordField() => tester.widget<TextField>(
      find.descendant(
        of: field(AuthStrings.passwordLabel),
        matching: find.byType(TextField),
      ),
    );

    expect(passwordField().obscureText, isTrue);

    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pump();

    expect(passwordField().obscureText, isFalse);
  });

  testWidgets('logs in with the trimmed username and stores the session', (
    tester,
  ) async {
    when(
      () => repository.login(username: '2012345-3744', password: 'secret'),
    ).thenAnswer((_) async => const Ok(AuthSession(username: '2012345-3744')));
    await pumpView(tester);

    await tester.enterText(field(AuthStrings.usernameLabel), '  2012345-3744 ');
    await tester.enterText(field(AuthStrings.passwordLabel), 'secret');
    await tester.tap(find.text(AuthStrings.submit));
    await tester.pumpAndSettle();

    verify(() => repository.login(username: '2012345-3744', password: 'secret'))
        .called(1);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(LoginView)),
    );
    expect(container.read(currentUsernameProvider), '2012345-3744');
  });

  testWidgets('shows the failure message when the login fails', (tester) async {
    when(() => repository.login(username: '2012345-3744', password: 'bad'))
        .thenAnswer(
          (_) async =>
              Err(AuthFailure(message: AuthStrings.invalidCredentials)),
        );
    await pumpView(tester);

    await tester.enterText(field(AuthStrings.usernameLabel), '2012345-3744');
    await tester.enterText(field(AuthStrings.passwordLabel), 'bad');
    await tester.tap(find.text(AuthStrings.submit));
    await tester.pumpAndSettle();

    expect(find.text(AuthStrings.invalidCredentials), findsOneWidget);
  });

  testWidgets('shows a progress state while logging in', (tester) async {
    final completer = Completer<Result<AuthSession>>();
    when(() => repository.login(username: '2012345-3744', password: 'secret'))
        .thenAnswer((_) => completer.future);
    await pumpView(tester);

    await tester.enterText(field(AuthStrings.usernameLabel), '2012345-3744');
    await tester.enterText(field(AuthStrings.passwordLabel), 'secret');
    await tester.tap(find.text(AuthStrings.submit));
    await tester.pump();

    expect(find.text(AuthStrings.loggingIn), findsOneWidget);

    completer.complete(Err(UnknownFailure(message: 'x')));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.genericError), findsOneWidget);
  });

  testWidgets('"forgot password" opens the recovery screen', (tester) async {
    await pumpView(tester);

    await tester.tap(find.text(AuthStrings.forgotPassword));
    await tester.pumpAndSettle();

    expect(find.text('route:${AppRoutes.forgotPassword}'), findsOneWidget);
  });
}
