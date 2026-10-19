import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/core/router/app_routes.dart';
import 'package:univalle_app/features/auth/auth_strings.dart';
import 'package:univalle_app/features/auth/presentation/providers/auth_providers.dart';
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
    when(() => repository.resetPassword(username: 'jdoe'))
        .thenAnswer((_) async => const Ok('j***@correounivalle.edu.co'));
    await pumpView(tester);

    await tester.enterText(find.byType(TextFormField), ' jdoe ');
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
    when(() => repository.resetPassword(username: 'jdoe'))
        .thenAnswer((_) async => Err(NetworkFailure(message: 'down')));
    await pumpView(tester);

    await tester.enterText(find.byType(TextFormField), 'jdoe');
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
    when(() => repository.resetPassword(username: 'jdoe'))
        .thenAnswer((_) async => const Ok('j***@correounivalle.edu.co'));
    await pumpView(tester);

    await tester.enterText(find.byType(TextFormField), 'jdoe');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    verify(() => repository.resetPassword(username: 'jdoe')).called(1);
  });
}
