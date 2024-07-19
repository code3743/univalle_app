import 'package:univalle_app/features/student_tabulate/domain/datasource/tabulate_datasource.dart';
import 'package:univalle_app/features/student_tabulate/domain/entities/tabulate.dart';
import 'package:univalle_app/features/student_tabulate/domain/repositories/tabulate_repository.dart';

class SiraTabulateRepositoryImpl implements TabulateRepository {
  final TabulateDataSource _datasource;

  SiraTabulateRepositoryImpl(this._datasource);

  @override
  Future<Tabulate> getTabulate(
      String studentId, String programId, String token) async {
    return await _datasource.getTabulate(studentId, programId, token);
  }
}
