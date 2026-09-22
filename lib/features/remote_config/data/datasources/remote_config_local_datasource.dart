import 'dart:convert';

import '../../../../core/storage/local_storage_service.dart';
import '../models/app_config_model.dart';

class RemoteConfigLocalDataSource {
  static const _snapshotKey = 'remote_config_snapshot';
  static const _dismissedUpdateKey = 'remote_config_dismissed_update';
  static const _seenWelcomeKey = 'remote_config_seen_welcome';

  final LocalStorageService _storage;
  const RemoteConfigLocalDataSource(this._storage);

  Future<void> saveConfigSnapshot(Map<String, dynamic> json) =>
      _storage.setString(_snapshotKey, jsonEncode(json));

  /// Returns null both when there is no cached snapshot and when the cached
  /// one fails to decode (treated the same as "no cache" rather than as an
  /// error the fail-open caller would need to handle).
  Future<AppConfigModel?> getConfigSnapshot() async {
    final raw = await _storage.getString(_snapshotKey);
    if (raw == null) return null;
    try {
      return AppConfigModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException {
      return null;
    }
  }

  Future<void> dismissUpdate(String latestVersion) =>
      _storage.setString(_dismissedUpdateKey, latestVersion);

  Future<String?> getDismissedUpdate() =>
      _storage.getString(_dismissedUpdateKey);

  Future<void> markWelcomeSeen(String fingerprint) =>
      _storage.setString(_seenWelcomeKey, fingerprint);

  Future<String?> getSeenWelcome() => _storage.getString(_seenWelcomeKey);
}
