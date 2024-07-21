import 'package:univalle_app/features/auth/domain/datasources/auth_datasource.dart';
import 'package:univalle_app/core/domain/entities/student.dart';
import 'package:univalle_app/features/auth/domain/repositories/auth_repository.dart';

class SiraAuthRepositoryImpl implements AuthRepository {
  final AuthDatasource _authDatasource;

  SiraAuthRepositoryImpl(this._authDatasource);

  @override
  Future<void> login(String user, String password) async {
    return _authDatasource.login(user, password);
  }

  @override
  Future<void> logout() async {
    return _authDatasource.logout();
  }

  @override
  Future<Student> getStudent() async {
    return _authDatasource.getStudent();
  }

  @override
  Future<bool> isLogged() async {
    return _authDatasource.isLogged();
  }
}
