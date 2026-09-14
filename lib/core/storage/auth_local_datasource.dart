import 'local_storage_service.dart';

class StoredCredentials {
  final String username;
  final String password;
  final String? photoUrl;
  const StoredCredentials({
    required this.username,
    required this.password,
    this.photoUrl,
  });
}

class AuthLocalDataSource {
  static const _usernameKey = 'auth_username';
  static const _passwordKey = 'auth_password';
  static const _photoUrlKey = 'auth_photo_url';

  final LocalStorageService _storage;
  const AuthLocalDataSource(this._storage);

  Future<void> saveCredentials({
    required String username,
    required String password,
  }) async {
    await _storage.setString(_usernameKey, username);
    await _storage.setString(_passwordKey, password);
  }

  Future<void> savePhotoUrl(String photoUrl) =>
      _storage.setString(_photoUrlKey, photoUrl);

  Future<StoredCredentials?> getCredentials() async {
    final username = await _storage.getString(_usernameKey);
    final password = await _storage.getString(_passwordKey);
    if (username == null || password == null) return null;
    final photoUrl = await _storage.getString(_photoUrlKey);
    return StoredCredentials(
      username: username,
      password: password,
      photoUrl: photoUrl,
    );
  }

  Future<void> clearCredentials() async {
    await _storage.remove(_usernameKey);
    await _storage.remove(_passwordKey);
    await _storage.remove(_photoUrlKey);
  }
}
