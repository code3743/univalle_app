class AppModule {
  final String key;
  final String label;
  final String icon;
  final String route;
  final String color;
  final bool disabled;
  final String? disabledMessage;

  const AppModule({
    required this.key,
    required this.label,
    required this.icon,
    required this.route,
    required this.color,
    this.disabled = false,
    this.disabledMessage,
  });
}
