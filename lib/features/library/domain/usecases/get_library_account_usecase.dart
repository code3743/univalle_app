import '../../../../core/error/result.dart';
import '../entities/library_account.dart';
import '../repositories/library_repository.dart';

class GetLibraryAccountUseCase {
  final LibraryRepository _repository;
  const GetLibraryAccountUseCase(this._repository);

  Future<Result<LibraryAccount>> call() {
    return _repository.getAccount();
  }
}
