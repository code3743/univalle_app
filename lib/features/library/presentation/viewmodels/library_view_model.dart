import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
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

  Future<Result<String>> renewLoan(String barcode) async {
    final result = await ref
        .read(renewLibraryLoanUseCaseProvider)
        .call(barcode);
    final account = state.value;
    if (result case Ok(:final value) when account != null) {
      state = AsyncData(
        LibraryAccount(
          currentFine: account.currentFine,
          currentLoans: [
            for (final loan in account.currentLoans)
              loan.code == barcode ? loan.copyWith(dueDate: value) : loan,
          ],
          history: account.history,
        ),
      );
    }
    return result;
  }
}
