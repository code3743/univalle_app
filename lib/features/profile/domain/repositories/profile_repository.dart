import '../../../../core/error/result.dart';
import '../entities/student.dart';

abstract interface class ProfileRepository {
  Future<Result<Student>> getStudent({required String username});
}
