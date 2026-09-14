import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/session/current_username_provider.dart';
import '../../domain/entities/tabulate.dart';
import '../providers/tabulate_providers.dart';

part 'tabulate_view_model.g.dart';

@riverpod
class TabulateViewModel extends _$TabulateViewModel {
  @override
  Future<Tabulate> build() async {
    final username = ref.watch(currentUsernameProvider);
    if (username == null) {
      throw StateError(
        'TabulateViewModel.build() called without an active session.',
      );
    }

    final result = await ref
        .read(getTabulateUseCaseProvider)
        .call(username: username);
    return result.fold(
      onError: (failure) => throw failure,
      onSuccess: (tabulate) => tabulate,
    );
  }
}
