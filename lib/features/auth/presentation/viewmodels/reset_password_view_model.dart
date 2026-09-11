import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../providers/auth_providers.dart';

part 'reset_password_view_model.g.dart';

@riverpod
class ResetPasswordViewModel extends _$ResetPasswordViewModel {
  @override
  Future<String?> build() async => null;

  Future<void> resetPassword({required String username}) async {
    state = const AsyncLoading();
    final result = await ref.read(resetPasswordUseCaseProvider).call(username: username);
    state = result.fold(
      onError: (failure) => AsyncError(failure, StackTrace.current),
      onSuccess: (email) => AsyncData(email),
    );
  }
}
