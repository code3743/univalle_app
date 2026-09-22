import '../../domain/entities/app_module.dart';

class AppModuleModel {
  final String key;
  final String label;
  final String icon;
  final String route;
  final String color;

  const AppModuleModel({
    required this.key,
    required this.label,
    required this.icon,
    required this.route,
    required this.color,
  });

  factory AppModuleModel.fromJson(Map<String, dynamic> json) {
    return AppModuleModel(
      key: json['key'] as String,
      label: json['label'] as String,
      icon: json['icon'] as String,
      route: json['route'] as String,
      color: json['color'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'key': key,
    'label': label,
    'icon': icon,
    'route': route,
    'color': color,
  };

  AppModule toEntity() =>
      AppModule(key: key, label: label, icon: icon, route: route, color: color);
}
