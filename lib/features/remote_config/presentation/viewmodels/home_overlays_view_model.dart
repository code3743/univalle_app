import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/app_config.dart';
import '../../domain/entities/welcome_banner.dart';
import '../providers/remote_config_providers.dart';

part 'home_overlays_view_model.g.dart';

/// Decides whether [HomeOverlays] should show the update sheet / welcome
/// dialog and persists dismissal, so the widget only orchestrates UI
/// (opening the sheet/dialog) instead of talking to storage directly.
@riverpod
class HomeOverlaysViewModel extends _$HomeOverlaysViewModel {
  @override
  void build() {}

  // A storage read failing is treated as "already dismissed" rather than
  // "never dismissed", so a broken cache can't make an overlay reappear on
  // every Home visit.
  Future<bool> shouldShowUpdateSheet(UpdateStatus update) async {
    if (!update.updateAvailable || update.updateRequired) return false;
    final result = await ref.read(getDismissedUpdateUseCaseProvider).call();
    final dismissed = result.fold(
      onError: (_) => update.latestVersion,
      onSuccess: (value) => value,
    );
    return dismissed != update.latestVersion;
  }

  Future<void> dismissUpdate(String latestVersion) =>
      ref.read(dismissUpdateUseCaseProvider).call(latestVersion);

  Future<bool> shouldShowWelcomeBanner(WelcomeBanner banner) async {
    if (!banner.enabled) return false;
    final fingerprint = _fingerprintOf(banner);
    final result = await ref.read(getSeenWelcomeUseCaseProvider).call();
    final seen = result.fold(
      onError: (_) => fingerprint,
      onSuccess: (value) => value,
    );
    return seen != fingerprint;
  }

  Future<void> markWelcomeSeen(WelcomeBanner banner) =>
      ref.read(markWelcomeSeenUseCaseProvider).call(_fingerprintOf(banner));

  // The backend exposes no id/version for the banner, so its own content is
  // the only signal that the admin published something new.
  String _fingerprintOf(WelcomeBanner banner) {
    final raw =
        '${banner.title}|${banner.description}|${banner.imageUrl ?? ''}';
    return md5.convert(utf8.encode(raw)).toString();
  }
}
