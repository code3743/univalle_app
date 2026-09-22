import '../../../../core/error/result.dart';
import '../entities/app_config.dart';
import '../entities/announcements_page.dart';

abstract interface class RemoteConfigRepository {
  Future<Result<AppConfig>> getConfig({
    required String platform,
    required String version,
  });

  Future<Result<AnnouncementsPage>> getAnnouncements({required int page});

  Future<Result<String?>> getDismissedUpdate();
  Future<Result<void>> dismissUpdate(String latestVersion);

  Future<Result<String?>> getSeenWelcome();
  Future<Result<void>> markWelcomeSeen(String fingerprint);
}
