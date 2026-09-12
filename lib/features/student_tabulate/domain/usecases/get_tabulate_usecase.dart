import '../../../../core/error/result.dart';
import '../entities/tabulate.dart';
import '../repositories/tabulate_repository.dart';

class GetTabulateUseCase {
  final TabulateRepository _repository;
  const GetTabulateUseCase(this._repository);

  Future<Result<Tabulate>> call({required String username}) {
    return _repository.getTabulate(username: username);
  }
}
