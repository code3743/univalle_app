import 'dart:ui' show Color;

import 'package:univalle_app/core/utils/svg_paths.dart';

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
    this.primaryColor = const Color(0xFF6A7F93),
    this.isUnderDevelopment = false,
  });
}

final List<ButtonServicesOptions> servicesOptions = [
  ButtonServicesOptions(
    title: 'Calificaciones',
    route: '/home/student-grades',
    icon: SvgPaths.ratings,
  ),
  ButtonServicesOptions(
    title: 'Tabulado',
    route: '/home/tabulate',
    icon: SvgPaths.tabulated,
  ),
  ButtonServicesOptions(
    title: 'Calificación docente',
    route: '/home/teaching-rating',
    icon: SvgPaths.teacherRating,
  ),
  ButtonServicesOptions(
    title: 'Carné digital',
    route: '/home/digital-card',
    icon: SvgPaths.digitalCard,
  ),
  ButtonServicesOptions(
    title: 'Resolución',
    route: '/home/resolution',
    icon: SvgPaths.resolution,
  ),
  ButtonServicesOptions(
    title: 'Restaurante',
    route: '',
    icon: SvgPaths.restaurant,
    isUnderDevelopment: true,
  ),
];
