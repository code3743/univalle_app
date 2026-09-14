import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/session/current_photo_url_provider.dart';
import '../../../../core/session/current_username_provider.dart';
import '../providers/auth_providers.dart';

part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  Future<bool> build() async {
    final result = await ref.read(restoreSessionUseCaseProvider).call();
    return result.fold(
      onError: (_) => false,
      onSuccess: (session) {
        if (session == null) return false;
        ref.read(currentUsernameProvider.notifier).set(session.username);
        ref.read(currentPhotoUrlProvider.notifier).set(session.photoUrl);
        return true;
      },
    );
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = const AsyncLoading();
    final result = await ref
        .read(loginUseCaseProvider)
        .call(username: username, password: password);
    state = result.fold(
      onError: (failure) => AsyncError(failure, StackTrace.current),
      onSuccess: (session) {
        ref.read(currentUsernameProvider.notifier).set(session.username);
        ref.read(currentPhotoUrlProvider.notifier).set(session.photoUrl);
        return const AsyncData(true);
      },
    );
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    final result = await ref.read(logoutUseCaseProvider).call();
    state = result.fold(
      onError: (failure) => AsyncError(failure, StackTrace.current),
      onSuccess: (_) {
        ref.read(currentUsernameProvider.notifier).clear();
        ref.read(currentPhotoUrlProvider.notifier).clear();
        return const AsyncData(false);
      },
    );
  }
}
