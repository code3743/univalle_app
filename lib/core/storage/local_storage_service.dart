abstract interface class LocalStorageService {
  Future<String?> getString(String key);
  Future<void> setString(String key, String value);

  Future<bool?> getBool(String key);
  Future<void> setBool(String key, bool value);

  Future<int?> getInt(String key);
  Future<void> setInt(String key, int value);

  Future<double?> getDouble(String key);
  Future<void> setDouble(String key, double value);

  Future<List<String>?> getStringList(String key);
  Future<void> setStringList(String key, List<String> value);

  Future<void> remove(String key);
  Future<void> clear();
}
