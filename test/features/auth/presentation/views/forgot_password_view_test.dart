import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/core/router/app_routes.dart';
import 'package:univalle_app/features/auth/auth_strings.dart';
import 'package:univalle_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:univalle_app/features/auth/presentation/viewmodels/reset_password_cooldown_view_model.dart';
import 'package:univalle_app/features/auth/presentation/views/forgot_password_view.dart';
import 'package:univalle_app/features/auth/presentation/widgets/reset_password_success_dialog.dart';

import '../../../../helpers/pump_app.dart';
import '../auth_fixtures.dart';

void main() {
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
  });

  Future<void> pumpView(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpRoutedApp(
      const ForgotPasswordView(),
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
  }

  testWidgets('requires a username', (tester) async {
    await pumpView(tester);

    await tester.tap(
      find.widgetWithText(FilledButton, AuthStrings.resetPasswordSubmit),
    );
    await tester.pump();

    expect(find.text(AuthStrings.usernameRequired), findsOneWidget);
    verifyNever(
      () => repository.resetPassword(username: any(named: 'username')),
    );
  });

  testWidgets('shows the success dialog and returns to login on accept', (
    tester,
  ) async {
    when(() => repository.resetPassword(username: '2012345-3744'))
        .thenAnswer((_) async => const Ok('j***@correounivalle.edu.co'));
    await pumpView(tester);

    await tester.enterText(find.byType(TextFormField), ' 2012345-3744 ');
    await tester.tap(
      find.widgetWithText(FilledButton, AuthStrings.resetPasswordSubmit),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ResetPasswordSuccessDialog), findsOneWidget);
    expect(find.text('j***@correounivalle.edu.co'), findsOneWidget);

    await tester.tap(find.text(AuthStrings.accept));
    await tester.pumpAndSettle();

    expect(find.text('route:${AppRoutes.login}'), findsOneWidget);
  });

  testWidgets('shows the failure message when the reset fails', (tester) async {
    when(() => repository.resetPassword(username: '2012345-3744'))
        .thenAnswer((_) async => Err(NetworkFailure(message: 'down')));
    await pumpView(tester);

    await tester.enterText(find.byType(TextFormField), '2012345-3744');
    await tester.tap(
      find.widgetWithText(FilledButton, AuthStrings.resetPasswordSubmit),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ResetPasswordSuccessDialog), findsNothing);
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('"back to login" goes to the login screen', (tester) async {
    await pumpView(tester);

    await tester.tap(find.text(AuthStrings.backToLogin));
    await tester.pumpAndSettle();

    expect(find.text('route:${AppRoutes.login}'), findsOneWidget);
  });

  testWidgets('submits from the keyboard action too', (tester) async {
    when(() => repository.resetPassword(username: '2012345-3744'))
        .thenAnswer((_) async => const Ok('j***@correounivalle.edu.co'));
    await pumpView(tester);

    await tester.enterText(find.byType(TextFormField), '2012345-3744');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    verify(() => repository.resetPassword(username: '2012345-3744')).called(1);
  });

  testWidgets('blocks resubmitting until the cooldown elapses', (tester) async {
    when(() => repository.resetPassword(username: '2012345-3744'))
        .thenAnswer((_) async => Err(NetworkFailure(message: 'down')));
    await pumpView(tester);

    await tester.enterText(find.byType(TextFormField), '2012345-3744');
    await tester.tap(
      find.widgetWithText(FilledButton, AuthStrings.resetPasswordSubmit),
    );
    await tester.pump();
    await tester.pump();

    final button = find.byType(FilledButton);
    expect(tester.widget<FilledButton>(button).onPressed, isNull);
    expect(
      find.text(AuthStrings.resetPasswordRetryIn(resetPasswordCooldownSeconds)),
      findsOneWidget,
    );

    await tester.pump(const Duration(seconds: resetPasswordCooldownSeconds));
    expect(tester.widget<FilledButton>(button).onPressed, isNotNull);
    expect(
      find.widgetWithText(FilledButton, AuthStrings.resetPasswordSubmit),
      findsOneWidget,
    );
  });

  testWidgets('a different username is not blocked by the cooldown', (
    tester,
  ) async {
    when(() => repository.resetPassword(username: '2012345-3744'))
        .thenAnswer((_) async => Err(NetworkFailure(message: 'down')));
    await pumpView(tester);

    await tester.enterText(find.byType(TextFormField), '2012345-3744');
    await tester.tap(
      find.widgetWithText(FilledButton, AuthStrings.resetPasswordSubmit),
    );
    await tester.pump();
    await tester.pump();
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );

    await tester.enterText(find.byType(TextFormField), '2099999-0000');
    await tester.pump();

    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNotNull,
    );
    await tester.pump(const Duration(seconds: resetPasswordCooldownSeconds));
  });
}
