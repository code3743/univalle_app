import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/auth/presentation/viewmodels/reset_password_cooldown_view_model.dart';

import '../../../../helpers/container.dart';

void main() {
  test('starts idle', () {
    final container = createContainer();

    expect(container.read(resetPasswordCooldownViewModelProvider('jdoe')), 0);
  });

  test('does not affect other usernames', () {
    final container = createContainer();
    container.listen(resetPasswordCooldownViewModelProvider('jdoe'), (_, _) {});

    container
        .read(resetPasswordCooldownViewModelProvider('jdoe').notifier)
        .start();

    expect(container.read(resetPasswordCooldownViewModelProvider('other')), 0);
  });

  testWidgets('counts down to zero after start', (tester) async {
    final container = createContainer();
    container.listen(resetPasswordCooldownViewModelProvider('jdoe'), (_, _) {});

    container
        .read(resetPasswordCooldownViewModelProvider('jdoe').notifier)
        .start();
    expect(
      container.read(resetPasswordCooldownViewModelProvider('jdoe')),
      resetPasswordCooldownSeconds,
    );

    await tester.pump(const Duration(seconds: 10));
    expect(
      container.read(resetPasswordCooldownViewModelProvider('jdoe')),
      resetPasswordCooldownSeconds - 10,
    );

    await tester.pump(const Duration(seconds: resetPasswordCooldownSeconds));
    expect(container.read(resetPasswordCooldownViewModelProvider('jdoe')), 0);
  });
}
