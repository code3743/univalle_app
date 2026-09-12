import '../../../../core/error/result.dart';
import '../entities/tabulate.dart';

abstract interface class TabulateRepository {
  Future<Result<Tabulate>> getTabulate({required String username});
}
