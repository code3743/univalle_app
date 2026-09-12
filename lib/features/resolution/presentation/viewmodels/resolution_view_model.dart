import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/session/current_username_provider.dart';
import '../../domain/entities/curriculum.dart';
import '../providers/resolution_providers.dart';

part 'resolution_view_model.g.dart';

@riverpod
class ResolutionViewModel extends _$ResolutionViewModel {
  @override
  Future<Curriculum> build() async {
    final username = ref.watch(currentUsernameProvider);
    if (username == null) {
      throw StateError(
        'ResolutionViewModel.build() called without an active session.',
      );
    }

    final result = await ref
        .read(getCurriculumUseCaseProvider)
        .call(username: username);
    return result.fold(
      onError: (failure) => throw failure,
      onSuccess: (curriculum) => curriculum,
    );
  }
}
