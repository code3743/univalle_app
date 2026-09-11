import '../../../../core/storage/local_storage_service.dart';

class StoredCredentials {
  final String username;
  final String password;
  const StoredCredentials({required this.username, required this.password});
}

class AuthLocalDataSource {
  static const _usernameKey = 'auth_username';
  static const _passwordKey = 'auth_password';

  final LocalStorageService _storage;
  const AuthLocalDataSource(this._storage);

  Future<void> saveCredentials({required String username, required String password}) async {
    await _storage.setString(_usernameKey, username);
    await _storage.setString(_passwordKey, password);
  }

  Future<StoredCredentials?> getCredentials() async {
    final username = await _storage.getString(_usernameKey);
    final password = await _storage.getString(_passwordKey);
    if (username == null || password == null) return null;
    return StoredCredentials(username: username, password: password);
  }

  Future<void> clearCredentials() async {
    await _storage.remove(_usernameKey);
    await _storage.remove(_passwordKey);
  }
}
