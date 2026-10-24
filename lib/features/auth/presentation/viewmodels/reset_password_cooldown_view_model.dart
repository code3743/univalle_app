import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reset_password_cooldown_view_model.g.dart';

const resetPasswordCooldownSeconds = 60;

// One cooldown per username; keepAlive so leaving and re-entering the screen can't skip the wait.
@Riverpod(keepAlive: true)
class ResetPasswordCooldownViewModel extends _$ResetPasswordCooldownViewModel {
  Timer? _timer;

  @override
  int build(String username) {
    ref.onDispose(() => _timer?.cancel());
    return 0;
  }

  void start() {
    _timer?.cancel();
    state = resetPasswordCooldownSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state - 1;
      if (state <= 0) timer.cancel();
    });
  }
}
