import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../error/exceptions.dart';
import 'local_storage_service.dart';

final class SharedPreferencesService implements LocalStorageService {
  final SharedPreferences _preferences;
  const SharedPreferencesService(this._preferences);

  @override
  Future<String?> getString(String key) => _guard(() => _preferences.getString(key));

  @override
  Future<void> setString(String key, String value) =>
      _guard(() => _preferences.setString(key, value));

  @override
  Future<bool?> getBool(String key) => _guard(() => _preferences.getBool(key));

  @override
  Future<void> setBool(String key, bool value) => _guard(() => _preferences.setBool(key, value));

  @override
  Future<int?> getInt(String key) => _guard(() => _preferences.getInt(key));

  @override
  Future<void> setInt(String key, int value) => _guard(() => _preferences.setInt(key, value));

  @override
  Future<double?> getDouble(String key) => _guard(() => _preferences.getDouble(key));

  @override
  Future<void> setDouble(String key, double value) =>
      _guard(() => _preferences.setDouble(key, value));

  @override
  Future<List<String>?> getStringList(String key) =>
      _guard(() => _preferences.getStringList(key));

  @override
  Future<void> setStringList(String key, List<String> value) =>
      _guard(() => _preferences.setStringList(key, value));

  @override
  Future<void> remove(String key) => _guard(() => _preferences.remove(key));

  @override
  Future<void> clear() => _guard(() => _preferences.clear());

  Future<T> _guard<T>(FutureOr<T> Function() action) async {
    try {
      return await action();
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
