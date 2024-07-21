import 'package:univalle_app/core/domain/entities/student.dart';

abstract class AuthDatasource {
  Future<void> login(String user, String password);
  Future<void> logout();
  Future<Student> getStudent();
  Future<bool> isLogged();
}
