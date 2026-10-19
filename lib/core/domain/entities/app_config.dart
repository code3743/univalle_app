import 'app_module.dart';
import 'welcome_banner.dart';

class AppConfig {
  final bool platformEnabled;
  final MaintenanceStatus maintenance;
  final UpdateStatus update;
  final List<AppModule> modules;
  final List<String> quickAccess;
  final WelcomeBanner welcome;

  const AppConfig({
    required this.platformEnabled,
    required this.maintenance,
    required this.update,
    required this.modules,
    required this.quickAccess,
    required this.welcome,
  });
}

class MaintenanceStatus {
  final bool enabled;
  final String title;
  final String message;

  const MaintenanceStatus({
    required this.enabled,
    required this.title,
    required this.message,
  });
}

class UpdateStatus {
  final String latestVersion;
  final bool updateAvailable;
  final bool updateRequired;
  final String storeUrl;
  final String message;

  const UpdateStatus({
    required this.latestVersion,
    required this.updateAvailable,
    required this.updateRequired,
    required this.storeUrl,
    required this.message,
  });
}
