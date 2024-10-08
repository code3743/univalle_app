import 'package:univalle_app/features/student_tabulate/domain/entities/tabulate.dart';

abstract class TabulateRepository {
  Future<Tabulate> getTabulate(
      String studentId, String programId, String token);
}
