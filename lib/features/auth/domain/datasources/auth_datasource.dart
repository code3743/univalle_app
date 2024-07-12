import 'package:univalle_app/features/auth/domain/entities/student.dart';

abstract class AuthDatasource {
  Future<void> login(String user, String password);
  Future<void> logout();
  Future<Student> getStudent();
}
