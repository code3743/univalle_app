import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

final sharedUtilityProvider = Provider<SharedStudentUtility>((ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return SharedStudentUtility(sharedPrefs);
});

class SharedStudentUtility {
  final SharedPreferences _sharedPreferences;
  SharedStudentUtility(this._sharedPreferences);

  String? getToken() {
    return _sharedPreferences.getString('token');
  }

  String? getStudentId() {
    return _sharedPreferences.getString('studentId');
  }

  String? getPassword() {
    return _sharedPreferences.getString('password');
  }

  Future<void> saveStudentData(
      String token, String studentId, String password) async {
    await _sharedPreferences.setString('token', token);
    await _sharedPreferences.setString('studentId', studentId);
    await _sharedPreferences.setString('password', password);
  }

  Future<void> clearStudentData() async {
    await _sharedPreferences.remove('token');
    await _sharedPreferences.remove('studentId');
    await _sharedPreferences.remove('password');
  }
}
