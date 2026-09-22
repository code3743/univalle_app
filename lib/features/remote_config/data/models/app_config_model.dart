import '../../domain/entities/app_config.dart';
import 'app_module_model.dart';
import 'welcome_banner_model.dart';

class AppConfigModel {
  final bool platformEnabled;
  final MaintenanceStatusModel maintenance;
  final UpdateStatusModel update;
  final List<AppModuleModel> modules;
  final List<String> quickAccess;
  final WelcomeBannerModel welcome;

  const AppConfigModel({
    required this.platformEnabled,
    required this.maintenance,
    required this.update,
    required this.modules,
    required this.quickAccess,
    required this.welcome,
  });

  // Round-trips the merged snapshot this app persists locally (see
  // RemoteConfigLocalDataSource) — the backend itself never returns this
  // shape from a single endpoint, see `fromParts`.
  factory AppConfigModel.fromJson(Map<String, dynamic> json) {
    return AppConfigModel(
      platformEnabled: json['platformEnabled'] as bool,
      maintenance: MaintenanceStatusModel.fromJson(
        json['maintenance'] as Map<String, dynamic>,
      ),
      update: UpdateStatusModel.fromJson(
        json['update'] as Map<String, dynamic>,
      ),
      modules: (json['modules'] as List<dynamic>)
          .map((m) => AppModuleModel.fromJson(m as Map<String, dynamic>))
          .toList(),
      quickAccess: (json['quickAccess'] as List<dynamic>).cast<String>(),
      welcome: WelcomeBannerModel.fromJson(
        json['welcome'] as Map<String, dynamic>,
      ),
    );
  }

  /// Builds the merged config from the backend's actual (split) response
  /// shape: `/app/config` only carries `platformEnabled`/`maintenance`/
  /// `update`, while modules and the welcome banner each live behind their
  /// own endpoint.
  factory AppConfigModel.fromParts({
    required Map<String, dynamic> config,
    required Map<String, dynamic> modules,
    required Map<String, dynamic> welcome,
  }) {
    return AppConfigModel(
      platformEnabled: config['platformEnabled'] as bool,
      maintenance: MaintenanceStatusModel.fromJson(
        config['maintenance'] as Map<String, dynamic>,
      ),
      update: UpdateStatusModel.fromJson(
        config['update'] as Map<String, dynamic>,
      ),
      modules: (modules['items'] as List<dynamic>)
          .map((m) => AppModuleModel.fromJson(m as Map<String, dynamic>))
          .toList(),
      quickAccess: (modules['quickAccess'] as List<dynamic>).cast<String>(),
      welcome: WelcomeBannerModel.fromJson(welcome),
    );
  }

  Map<String, dynamic> toJson() => {
    'platformEnabled': platformEnabled,
    'maintenance': maintenance.toJson(),
    'update': update.toJson(),
    'modules': modules.map((m) => m.toJson()).toList(),
    'quickAccess': quickAccess,
    'welcome': welcome.toJson(),
  };

  AppConfig toEntity() => AppConfig(
    platformEnabled: platformEnabled,
    maintenance: maintenance.toEntity(),
    update: update.toEntity(),
    modules: modules.map((m) => m.toEntity()).toList(),
    quickAccess: quickAccess,
    welcome: welcome.toEntity(),
  );
}

class MaintenanceStatusModel {
  final bool enabled;
  final String title;
  final String message;

  const MaintenanceStatusModel({
    required this.enabled,
    required this.title,
    required this.message,
  });

  factory MaintenanceStatusModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceStatusModel(
      enabled: json['enabled'] as bool,
      title: json['title'] as String,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'title': title,
    'message': message,
  };

  MaintenanceStatus toEntity() =>
      MaintenanceStatus(enabled: enabled, title: title, message: message);
}

class UpdateStatusModel {
  final String latestVersion;
  final bool updateAvailable;
  final bool updateRequired;
  final String storeUrl;
  final String message;

  const UpdateStatusModel({
    required this.latestVersion,
    required this.updateAvailable,
    required this.updateRequired,
    required this.storeUrl,
    required this.message,
  });

  factory UpdateStatusModel.fromJson(Map<String, dynamic> json) {
    return UpdateStatusModel(
      latestVersion: json['latestVersion'] as String,
      updateAvailable: json['updateAvailable'] as bool,
      updateRequired: json['updateRequired'] as bool,
      storeUrl: json['storeUrl'] as String,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'latestVersion': latestVersion,
    'updateAvailable': updateAvailable,
    'updateRequired': updateRequired,
    'storeUrl': storeUrl,
    'message': message,
  };

  UpdateStatus toEntity() => UpdateStatus(
    latestVersion: latestVersion,
    updateAvailable: updateAvailable,
    updateRequired: updateRequired,
    storeUrl: storeUrl,
    message: message,
  );
}
