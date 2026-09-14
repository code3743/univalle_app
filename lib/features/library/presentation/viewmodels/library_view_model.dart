import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/library_account.dart';
import '../providers/library_providers.dart';

part 'library_view_model.g.dart';

@riverpod
class LibraryViewModel extends _$LibraryViewModel {
  @override
  Future<LibraryAccount> build() async {
    final result = await ref.read(getLibraryAccountUseCaseProvider).call();
    return result.fold(
      onError: (failure) => throw failure,
      onSuccess: (account) => account,
    );
  }
}
