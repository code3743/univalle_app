import 'package:univalle_app/core/entities/student.dart';

abstract class AuthRepository {
  Future<void> login(String user, String password);
  Future<void> logout();
  Future<Student> getStudent();
  Future<bool> isLogged();
}
