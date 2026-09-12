import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/session/current_username_provider.dart';
import '../../domain/entities/grades.dart';
import '../providers/grades_providers.dart';

part 'grades_view_model.g.dart';

@riverpod
class GradesViewModel extends _$GradesViewModel {
  @override
  Future<List<Grades>> build() async {
    final username = ref.watch(currentUsernameProvider);
    if (username == null) {
      throw StateError('GradesViewModel.build() called without an active session.');
    }

    final result = await ref.read(getGradesUseCaseProvider).call(username: username);
    return result.fold(onError: (failure) => throw failure, onSuccess: (grades) => grades);
  }
}
