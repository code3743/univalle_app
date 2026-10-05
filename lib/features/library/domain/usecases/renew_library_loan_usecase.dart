import '../../../../core/error/result.dart';
import '../repositories/library_repository.dart';

class RenewLibraryLoanUseCase {
  final LibraryRepository _repository;
  const RenewLibraryLoanUseCase(this._repository);

  Future<Result<String>> call(String barcode) {
    return _repository.renewLoan(barcode);
  }
}
