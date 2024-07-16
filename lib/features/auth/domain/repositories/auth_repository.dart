import 'package:univalle_app/features/auth/domain/entities/student.dart';

abstract class AuthRepository {
  Future<void> login(String user, String password);
  Future<void> logout();
  Future<Student> getStudent();
  Future<bool> isLogged();
}
