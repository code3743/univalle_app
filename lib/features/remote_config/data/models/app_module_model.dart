import '../../domain/entities/app_module.dart';

class AppModuleModel {
  final String key;
  final String label;
  final String icon;
  final String route;
  final String color;
  final bool disabled;
  final String? disabledMessage;

  const AppModuleModel({
    required this.key,
    required this.label,
    required this.icon,
    required this.route,
    required this.color,
    this.disabled = false,
    this.disabledMessage,
  });

  factory AppModuleModel.fromJson(Map<String, dynamic> json) {
    return AppModuleModel(
      key: json['key'] as String,
      label: json['label'] as String,
      icon: json['icon'] as String,
      route: json['route'] as String,
      color: json['color'] as String,
      disabled: json['disabled'] as bool? ?? false,
      disabledMessage: json['disabledMessage'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'key': key,
    'label': label,
    'icon': icon,
    'route': route,
    'color': color,
    'disabled': disabled,
    'disabledMessage': disabledMessage,
  };

  AppModule toEntity() => AppModule(
    key: key,
    label: label,
    icon: icon,
    route: route,
    color: color,
    disabled: disabled,
    disabledMessage: disabledMessage,
  );
}
