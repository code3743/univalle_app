abstract final class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );
  static const String configPath = '/app/config';
  static const String modulesPath = '/app/modules';
  static const String welcomePath = '/app/welcome';
  static const String announcementsPath = '/app/announcements';
}
