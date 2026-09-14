import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/session/current_username_provider.dart';
import '../../domain/entities/student.dart';
import '../providers/profile_providers.dart';

part 'profile_view_model.g.dart';

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  @override
  Future<Student> build() async {
    final username = ref.watch(currentUsernameProvider);
    if (username == null) {
      throw StateError('ProfileViewModel.build() called without an active session.');
    }

    final result = await ref.read(getStudentUseCaseProvider).call(username: username);
    return result.fold(onError: (failure) => throw failure, onSuccess: (student) => student);
  }
}
