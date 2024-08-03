import 'dart:ui' show Color;

class ButtonServicesOptions {
  final String title;
  final String route;
  final String icon;
  final bool isUnderDevelopment;
  final Color primaryColor;

  ButtonServicesOptions({
    required this.title,
    required this.route,
    required this.icon,
    this.primaryColor = const Color(0xFF8B8B8B),
    this.isUnderDevelopment = false,
  });
}

final List<ButtonServicesOptions> servicesOptions = [
  ButtonServicesOptions(
    title: 'Calificaciones',
    route: '/home/student-grades',
    icon: 'assets/svg/Achievement.svg',
  ),
  ButtonServicesOptions(
    title: 'Tabulado',
    route: '/home/tabulate',
    icon: 'assets/svg/Book.svg',
  ),
  ButtonServicesOptions(
    title: 'Calificación docente',
    route: '/home/teaching-rating',
    icon: 'assets/svg/Discuss.svg',
  ),
  ButtonServicesOptions(
    title: 'Carné digital',
    route: '/home/digital-card',
    icon: 'assets/svg/E-learning.svg',
  ),
  ButtonServicesOptions(
    title: 'Resolución',
    route: '/home/resolution',
    icon: 'assets/svg/Certificate.svg',
  ),
  ButtonServicesOptions(
    title: 'Restaurante',
    route: '',
    icon: 'assets/svg/Bagpack.svg',
    isUnderDevelopment: true,
    primaryColor: const Color(0xFF6A7F93),
  ),
];
